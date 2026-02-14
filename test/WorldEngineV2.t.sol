// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import "../src/WorldEngineV2.sol";
import "../src/MockSTEALTH.sol";

contract WorldEngineV2Test is Test {
    WorldEngineV2 engine;
    MockSTEALTH token;
    address orchestrator;
    address alice = address(0xA11CE);
    address bob = address(0xB0B);

    bytes32 roundId = keccak256("round1");
    bytes32 ideaA = keccak256("ideaA");
    bytes32 ideaB = keccak256("ideaB");

    function setUp() public {
        orchestrator = address(this);
        token = new MockSTEALTH();
        engine = new WorldEngineV2(address(token));

        // Mint and approve for alice and bob
        token.mint(alice, 100 ether);
        token.mint(bob, 100 ether);

        vm.prank(alice);
        token.approve(address(engine), type(uint256).max);
        vm.prank(bob);
        token.approve(address(engine), type(uint256).max);
    }

    function test_startRound() public {
        engine.startRound(roundId);
        WorldEngineV2.Round memory r = engine.getRound(roundId);
        assertTrue(r.active);
        assertFalse(r.settled);
        assertEq(r.id, roundId);
    }

    function test_startRound_duplicate_reverts() public {
        engine.startRound(roundId);
        vm.expectRevert("Round exists");
        engine.startRound(roundId);
    }

    function test_believe() public {
        engine.startRound(roundId);
        vm.prank(alice);
        engine.believe(roundId, ideaA, 1 ether);

        (uint256 amt, bool isChallenge, bytes32 idea) = engine.getStake(roundId, alice);
        assertEq(amt, 1 ether);
        assertFalse(isChallenge);
        assertEq(idea, ideaA);

        WorldEngineV2.Round memory r = engine.getRound(roundId);
        assertEq(r.totalPool, 1 ether);
        assertEq(r.believePool, 1 ether);
        assertEq(token.balanceOf(address(engine)), 1 ether);
    }

    function test_challenge() public {
        engine.startRound(roundId);
        vm.prank(bob);
        engine.challenge(roundId, ideaB, 2 ether);

        (uint256 amt, bool isChallenge,) = engine.getStake(roundId, bob);
        assertEq(amt, 2 ether);
        assertTrue(isChallenge);

        WorldEngineV2.Round memory r = engine.getRound(roundId);
        assertEq(r.challengePool, 2 ether);
        assertEq(token.balanceOf(address(engine)), 2 ether);
    }

    function test_settle_and_claim() public {
        engine.startRound(roundId);
        vm.prank(alice);
        engine.believe(roundId, ideaA, 1 ether);
        vm.prank(bob);
        engine.challenge(roundId, ideaB, 1 ether);

        engine.settle(roundId, ideaA);

        WorldEngineV2.Round memory r = engine.getRound(roundId);
        assertFalse(r.active);
        assertTrue(r.settled);
        assertEq(r.winningIdeaId, ideaA);
        assertEq(engine.treasuryBalance(), 0.2 ether);

        address[] memory users = new address[](1);
        users[0] = alice;
        uint256[] memory amounts = new uint256[](1);
        amounts[0] = 1.8 ether;
        engine.setClaimable(users, amounts);

        assertEq(engine.claimable(alice), 1.8 ether);

        uint256 balBefore = token.balanceOf(alice);
        vm.prank(alice);
        engine.claim();
        assertEq(token.balanceOf(alice) - balBefore, 1.8 ether);
        assertEq(engine.claimable(alice), 0);
    }

    function test_withdrawTreasury() public {
        engine.startRound(roundId);
        vm.prank(alice);
        engine.believe(roundId, ideaA, 1 ether);
        engine.settle(roundId, ideaA);

        uint256 expected = 0.1 ether;
        assertEq(engine.treasuryBalance(), expected);

        uint256 balBefore = token.balanceOf(orchestrator);
        engine.withdrawTreasury();
        assertEq(token.balanceOf(orchestrator) - balBefore, expected);
        assertEq(engine.treasuryBalance(), 0);
    }

    function test_onlyOrchestrator_startRound() public {
        vm.prank(alice);
        vm.expectRevert("Not orchestrator");
        engine.startRound(roundId);
    }

    function test_onlyOrchestrator_settle() public {
        engine.startRound(roundId);
        vm.prank(alice);
        vm.expectRevert("Not orchestrator");
        engine.settle(roundId, ideaA);
    }

    function test_onlyOrchestrator_setClaimable() public {
        address[] memory u = new address[](0);
        uint256[] memory a = new uint256[](0);
        vm.prank(alice);
        vm.expectRevert("Not orchestrator");
        engine.setClaimable(u, a);
    }

    function test_onlyOrchestrator_withdrawTreasury() public {
        vm.prank(alice);
        vm.expectRevert("Not orchestrator");
        engine.withdrawTreasury();
    }

    function test_double_believe_reverts() public {
        engine.startRound(roundId);
        vm.startPrank(alice);
        engine.believe(roundId, ideaA, 1 ether);
        vm.expectRevert("Already staked");
        engine.believe(roundId, ideaB, 1 ether);
        vm.stopPrank();
    }

    function test_double_challenge_reverts() public {
        engine.startRound(roundId);
        vm.startPrank(bob);
        engine.challenge(roundId, ideaA, 1 ether);
        vm.expectRevert("Already staked");
        engine.challenge(roundId, ideaB, 1 ether);
        vm.stopPrank();
    }

    function test_believe_then_challenge_reverts() public {
        engine.startRound(roundId);
        vm.startPrank(alice);
        engine.believe(roundId, ideaA, 1 ether);
        vm.expectRevert("Already staked");
        engine.challenge(roundId, ideaB, 1 ether);
        vm.stopPrank();
    }

    function test_believe_inactive_round_reverts() public {
        vm.prank(alice);
        vm.expectRevert("Round not active");
        engine.believe(roundId, ideaA, 1 ether);
    }

    function test_believe_zero_amount_reverts() public {
        engine.startRound(roundId);
        vm.prank(alice);
        vm.expectRevert("Must stake");
        engine.believe(roundId, ideaA, 0);
    }

    function test_claim_nothing_reverts() public {
        vm.prank(alice);
        vm.expectRevert("Nothing to claim");
        engine.claim();
    }
}
