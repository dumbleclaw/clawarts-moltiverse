// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract WorldEngine {
    address public orchestrator;

    struct Round {
        bytes32 id;
        bool active;
        bool settled;
        bytes32 winningIdeaId;
        uint256 totalPool;
        uint256 believePool;
        uint256 challengePool;
    }

    struct Stake {
        uint256 amount;
        bool isChallenge;
        bytes32 ideaId;
        bool claimed;
    }

    mapping(bytes32 => Round) public rounds;
    mapping(bytes32 => mapping(address => Stake)) public stakes;
    mapping(bytes32 => mapping(bytes32 => uint256)) public ideaBelievePool;
    mapping(address => uint256) public claimable;

    uint256 public treasuryBalance;
    uint256 public constant TREASURY_FEE_BPS = 1000;
    uint256 public constant CHALLENGER_BONUS_BPS = 1000;

    event RoundStarted(bytes32 indexed roundId);
    event Believed(bytes32 indexed roundId, bytes32 indexed ideaId, address indexed user, uint256 amount);
    event Challenged(bytes32 indexed roundId, bytes32 indexed ideaId, address indexed user, uint256 amount);
    event RoundSettled(bytes32 indexed roundId, bytes32 winningIdeaId, uint256 totalPool);
    event Claimed(address indexed user, uint256 amount);
    event TreasuryWithdrawn(uint256 amount);

    modifier onlyOrchestrator() {
        require(msg.sender == orchestrator, "Not orchestrator");
        _;
    }

    constructor() {
        orchestrator = msg.sender;
    }

    function startRound(bytes32 roundId) external onlyOrchestrator {
        require(!rounds[roundId].active, "Round exists");
        rounds[roundId] = Round(roundId, true, false, bytes32(0), 0, 0, 0);
        emit RoundStarted(roundId);
    }

    function believe(bytes32 roundId, bytes32 ideaId) external payable {
        require(rounds[roundId].active, "Round not active");
        require(msg.value > 0, "Must stake");
        require(stakes[roundId][msg.sender].amount == 0, "Already staked");

        stakes[roundId][msg.sender] = Stake(msg.value, false, ideaId, false);
        rounds[roundId].totalPool += msg.value;
        rounds[roundId].believePool += msg.value;
        ideaBelievePool[roundId][ideaId] += msg.value;

        emit Believed(roundId, ideaId, msg.sender, msg.value);
    }

    function challenge(bytes32 roundId, bytes32 ideaId) external payable {
        require(rounds[roundId].active, "Round not active");
        require(msg.value > 0, "Must stake");
        require(stakes[roundId][msg.sender].amount == 0, "Already staked");

        stakes[roundId][msg.sender] = Stake(msg.value, true, ideaId, false);
        rounds[roundId].totalPool += msg.value;
        rounds[roundId].challengePool += msg.value;

        emit Challenged(roundId, ideaId, msg.sender, msg.value);
    }

    function settle(bytes32 roundId, bytes32 winningIdeaId) external onlyOrchestrator {
        Round storage r = rounds[roundId];
        require(r.active, "Not active");
        require(!r.settled, "Already settled");

        r.active = false;
        r.settled = true;
        r.winningIdeaId = winningIdeaId;

        uint256 pool = r.totalPool;
        uint256 treasuryFee = (pool * TREASURY_FEE_BPS) / 10000;
        treasuryBalance += treasuryFee;

        emit RoundSettled(roundId, winningIdeaId, pool);
    }

    function setClaimable(address[] calldata users, uint256[] calldata amounts) external onlyOrchestrator {
        require(users.length == amounts.length, "Length mismatch");
        for (uint256 i = 0; i < users.length; i++) {
            claimable[users[i]] += amounts[i];
        }
    }

    function claim() external {
        uint256 amount = claimable[msg.sender];
        require(amount > 0, "Nothing to claim");
        claimable[msg.sender] = 0;
        (bool ok,) = msg.sender.call{value: amount}("");
        require(ok, "Transfer failed");
        emit Claimed(msg.sender, amount);
    }

    function withdrawTreasury() external onlyOrchestrator {
        uint256 amount = treasuryBalance;
        treasuryBalance = 0;
        (bool ok,) = orchestrator.call{value: amount}("");
        require(ok, "Transfer failed");
        emit TreasuryWithdrawn(amount);
    }

    function getStake(bytes32 roundId, address user) external view returns (uint256 amount, bool isChallenge, bytes32 ideaId) {
        Stake memory s = stakes[roundId][user];
        return (s.amount, s.isChallenge, s.ideaId);
    }

    function getRound(bytes32 roundId) external view returns (Round memory) {
        return rounds[roundId];
    }
}
