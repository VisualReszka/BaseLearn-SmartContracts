// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import "lib/openzeppelin-contracts/contracts/utils/structs/EnumerableSet.sol";

contract WeightedVoting is ERC20 {
    using EnumerableSet for EnumerableSet.AddressSet;

    uint256 public constant maxSupply = 1_000_000;

    error TokensClaimed();
    error AllTokensClaimed();
    error NoTokensHeld();
    error QuorumTooHigh(uint256 quorum);
    error AlreadyVoted();
    error VotingClosed();

    enum Votes {
        FOR,
        AGAINST,
        ABSTAIN
    }

    struct Issue {
        EnumerableSet.AddressSet voters;  // 1
        string issueDesc;                 // 2
        uint256 votesFor;                 // 3
        uint256 votesAgainst;             // 4
        uint256 votesAbstain;             // 5
        uint256 totalVotes;               // 6
        uint256 quorum;                   // 7
        bool passed;                      // 8
        bool closed;                      // 9
    }

    // Define the IssueView struct before it's used
    struct IssueView {
        address[] voters;
        string issueDesc;
        uint256 votesFor;
        uint256 votesAgainst;
        uint256 votesAbstain;
        uint256 totalVotes;
        uint256 quorum;
        bool passed;
        bool closed;
    }

    Issue[] private issues;
    mapping(address => bool) public hasClaimed;

    constructor() ERC20("WeightedVotingToken", "WVT") {
        // Burn the zeroeth element of issues
        issues.push();
    }

    // Override decimals to set it to 0
    function decimals() public view virtual override returns (uint8) {
        return 0;
    }

    function claim() public {
        if (hasClaimed[msg.sender]) {
            revert TokensClaimed();
        }
        if (totalSupply() + 100 > maxSupply) {
            revert AllTokensClaimed();
        }
        hasClaimed[msg.sender] = true;
        _mint(msg.sender, 100);
    }

    function createIssue(string calldata _issueDesc, uint256 _quorum) external returns (uint256) {
        if (balanceOf(msg.sender) == 0) {
            revert NoTokensHeld();
        }
        if (_quorum > totalSupply()) {
            revert QuorumTooHigh(_quorum);
        }
        Issue storage newIssue = issues.push();
        newIssue.issueDesc = _issueDesc;
        newIssue.quorum = _quorum;
        return issues.length - 1;
    }

    function getIssue(uint256 _issueId) external view returns (IssueView memory) {
        Issue storage issue = issues[_issueId];
        return IssueView({
            voters: issue.voters.values(),
            issueDesc: issue.issueDesc,
            votesFor: issue.votesFor,
            votesAgainst: issue.votesAgainst,
            votesAbstain: issue.votesAbstain,
            totalVotes: issue.totalVotes,
            quorum: issue.quorum,
            passed: issue.passed,
            closed: issue.closed
        });
    }

    function vote(uint256 _issueId, Votes _vote) public {
        Issue storage issue = issues[_issueId];
        if (issue.closed) {
            revert VotingClosed();
        }
        if (issue.voters.contains(msg.sender)) {
            revert AlreadyVoted();
        }
        uint256 voterBalance = balanceOf(msg.sender);
        if (voterBalance == 0) {
            revert NoTokensHeld();
        }
        issue.voters.add(msg.sender);
        issue.totalVotes += voterBalance;
        if (_vote == Votes.FOR) {
            issue.votesFor += voterBalance;
        } else if (_vote == Votes.AGAINST) {
            issue.votesAgainst += voterBalance;
        } else if (_vote == Votes.ABSTAIN) {
            issue.votesAbstain += voterBalance;
        }
        if (issue.totalVotes >= issue.quorum) {
            issue.closed = true;
            if (issue.votesFor > issue.votesAgainst) {
                issue.passed = true;
            }
        }
    }
}
