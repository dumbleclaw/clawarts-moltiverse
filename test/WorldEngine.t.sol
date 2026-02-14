// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import "../src/WorldEngine.sol";

contract WorldEngineTest is Test {
    WorldEngine engine;
    address orchestrator;
    address alice = address(0xA11CE);
    address bob = address(0xB0B);

    bytes32 roundId = keccak256("round1");
    bytes32 ideaA = keccak256("ideaA");
    bytes32 ideaB = keccak256("ideaB");

    function setUp() public {
        orchestrator = address(this);
        engine = new WorldEngine();
        vm.deal(alice, 10 ether);
        vm.deal(bob, 10 ether);
    }

    // 1. startRound
    function test_startRound() public {
        engine.startRound(roundId);
        WorldEngine.Round memory r = engine.getRound(roundId);
        assertTrue(r.active);
        assertFalse(r.settled);
        assertEq(r.id, roundId);
    }

    function test_startRound_duplicate_reverts() public {
        engine.startRound(roundId);
        vm.expectRevert("Round exists");
        engine.startRound(roundId);
    }

    // 2. believe + challenge
    function test_believe() public {
        engine.startRound(roundId);
        vm.prank(alice);
        engine.believe{value: 1 ether}(roundId, ideaA);

        (uint256 amt, bool isChallenge, bytes32 idea) = engine.getStake(roundId, alice);
        assertEq(amt, 1 ether);
        assertFalse(isChallenge);
        assertEq(idea, ideaA);

        WorldEngine.Round memory r = engine.getRound(roundId);
        assertEq(r.totalPool, 1 ether);
        assertEq(r.believePool, 1 ether);
    }

    function test_challenge() public {
        engine.startRound(roundId);
        vm.prank(bob);
        engine.challenge{value: 2 ether}(roundId, ideaB);

        (uint256 amt, bool isChallenge,) = engine.getStake(roundId, bob);
        assertEq(amt, 2 ether);
        assertTrue(isChallenge);

        WorldEngine.Round memory r = engine.getRound(roundId);
        assertEq(r.challengePool, 2 ether);
    }

    // 3. settle + setClaimable + claim
    function test_settle_and_claim() public {
        engine.startRound(roundId);
        vm.prank(alice);
        engine.believe{value: 1 ether}(roundId, ideaA);
        vm.prank(bob);
        engine.challenge{value: 1 ether}(roundId, ideaB);

        engine.settle(roundId, ideaA);

        WorldEngine.Round memory r = engine.getRound(roundId);
        assertFalse(r.active);
        assertTrue(r.settled);
        assertEq(r.winningIdeaId, ideaA);
        // treasury = 10% of 2 ether = 0.2 ether
        assertEq(engine.treasuryBalance(), 0.2 ether);

        // Set claimable for alice (winner gets 1.8 ether)
        address[] memory users = new address[](1);
        users[0] = alice;
        uint256[] memory amounts = new uint256[](1);
        amounts[0] = 1.8 ether;
        engine.setClaimable(users, amounts);

        assertEq(engine.claimable(alice), 1.8 ether);

        uint256 balBefore = alice.balance;
        vm.prank(alice);
        engine.claim();
        assertEq(alice.balance - balBefore, 1.8 ether);
        assertEq(engine.claimable(alice), 0);
    }

    // 4. Treasury withdrawal
    function test_withdrawTreasury() public {
        engine.startRound(roundId);
        vm.prank(alice);
        engine.believe{value: 1 ether}(roundId, ideaA);
        engine.settle(roundId, ideaA);

        uint256 expected = 0.1 ether; // 10% of 1 ether
        assertEq(engine.treasuryBalance(), expected);

        uint256 balBefore = orchestrator.balance;
        engine.withdrawTreasury();
        assertEq(orchestrator.balance - balBefore, expected);
        assertEq(engine.treasuryBalance(), 0);
    }

    // 5. Access control
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

    // 6. Double-stake prevention
    function test_double_believe_reverts() public {
        engine.startRound(roundId);
        vm.startPrank(alice);
        engine.believe{value: 1 ether}(roundId, ideaA);
        vm.expectRevert("Already staked");
        engine.believe{value: 1 ether}(roundId, ideaB);
        vm.stopPrank();
    }

    function test_double_challenge_reverts() public {
        engine.startRound(roundId);
        vm.startPrank(bob);
        engine.challenge{value: 1 ether}(roundId, ideaA);
        vm.expectRevert("Already staked");
        engine.challenge{value: 1 ether}(roundId, ideaB);
        vm.stopPrank();
    }

    function test_believe_then_challenge_reverts() public {
        engine.startRound(roundId);
        vm.startPrank(alice);
        engine.believe{value: 1 ether}(roundId, ideaA);
        vm.expectRevert("Already staked");
        engine.challenge{value: 1 ether}(roundId, ideaB);
        vm.stopPrank();
    }

    // Edge cases
    function test_believe_inactive_round_reverts() public {
        vm.prank(alice);
        vm.expectRevert("Round not active");
        engine.believe{value: 1 ether}(roundId, ideaA);
    }

    function test_believe_zero_value_reverts() public {
        engine.startRound(roundId);
        vm.prank(alice);
        vm.expectRevert("Must stake");
        engine.believe{value: 0}(roundId, ideaA);
    }

    function test_claim_nothing_reverts() public {
        vm.prank(alice);
        vm.expectRevert("Nothing to claim");
        engine.claim();
    }

    receive() external payable {}
}
