// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

contract ClawartsWorld {
    address public orchestrator;
    uint256 public roundCount;
    uint256 public totalSpells;
    uint256 public totalCharacters;

    struct RoundResult {
        string roundId;
        string winnerName;
        bytes32 stateHash;    // keccak of full off-chain state
        uint256 votesFor;
        uint256 votesAgainst;
        uint256 timestamp;
    }

    mapping(uint256 => RoundResult) public rounds;
    mapping(address => bool) public participants;
    uint256 public participantCount;

    event RoundCompleted(uint256 indexed roundNum, string roundId, string winnerName, bytes32 stateHash);
    event ParticipantJoined(address indexed participant);
    event SpellCast(address indexed caster, string word, uint256 roundNum);

    modifier onlyOrchestrator() {
        require(msg.sender == orchestrator, "Not orchestrator");
        _;
    }

    constructor() {
        orchestrator = msg.sender;
    }

    function joinWorld() external {
        require(!participants[msg.sender], "Already joined");
        participants[msg.sender] = true;
        participantCount++;
        emit ParticipantJoined(msg.sender);
    }

    function castSpell(string calldata word) external {
        require(participants[msg.sender] || msg.sender == orchestrator, "Not a participant");
        totalSpells++;
        emit SpellCast(msg.sender, word, roundCount + 1);
    }

    function completeRound(
        string calldata roundId,
        string calldata winnerName,
        bytes32 stateHash,
        uint256 votesFor,
        uint256 votesAgainst,
        uint256 newCharacters
    ) external onlyOrchestrator {
        roundCount++;
        totalCharacters += newCharacters;
        rounds[roundCount] = RoundResult({
            roundId: roundId,
            winnerName: winnerName,
            stateHash: stateHash,
            votesFor: votesFor,
            votesAgainst: votesAgainst,
            timestamp: block.timestamp
        });
        emit RoundCompleted(roundCount, roundId, winnerName, stateHash);
    }

    function getRound(uint256 num) external view returns (RoundResult memory) {
        return rounds[num];
    }
}
