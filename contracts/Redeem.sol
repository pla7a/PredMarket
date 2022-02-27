// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

interface YesNo {
        function transferFrom(address from, address to, uint256 amount) external returns (bool);
        function transfer(address recipient, uint256 amount) external returns (bool);
        function allowance(address owner, address spender) external returns (uint256);
    }

interface Payment {
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external returns (uint256);
}

interface Minter {
    function viewTokens() external view returns(YesNo, YesNo, YesNo);
    function viewPayment() external view returns (Payment);
}


contract Redeem is Ownable {
    enum Outcome{Yes, No, Indet}
    uint256 public threshold;
    uint256 public totalVotes;
    mapping(Outcome => uint256) votes;
    mapping(address => bool) signers;
    mapping(Outcome => YesNo) outcomeAddr;
    mapping(address => bool) alreadyVoted;
    bool outcome;
    YesNo public yesToken;
    YesNo public noToken;
    YesNo public indetToken;
    Payment public payment;
    Minter public minter;

    constructor(uint256 _threshold, address _minter) {
        signers[msg.sender] = true;
        threshold = _threshold;
        minter = Minter(_minter);
        (yesToken, noToken, indetToken) = minter.viewTokens();
        payment = minter.viewPayment();
        // True = Yes, False = No
        outcomeAddr[Outcome.Yes] = yesToken;
        outcomeAddr[Outcome.No] = noToken;
        outcomeAddr[Outcome.Indet] = indetToken;
    }

    // Only signers can vote (and resolve) markets
    modifier onlyAdmin() {
        require(signers[msg.sender] == true);
            _;
    }

    // Whether or not a market has been decided
    modifier decided() {
        require(totalVotes >= threshold);
        _;
    }

    function whitelist(address admin) public onlyOwner {
        signers[admin] = true;
    }

    // 0 = Yes, 1 = No, 2 = Indeterminate
    function voteOutcome(uint8 voteTF) public onlyAdmin {
        require(!alreadyVoted[msg.sender]);
        votes[Outcome(voteTF)] += 1;
        totalVotes += 1;
        alreadyVoted[msg.sender] = true;
    }

    function checkThreshold() public view returns (bool){
        if (totalVotes >= threshold){
            return true;
        }
        else {
            return false;
        }
    }

    function decideOutcome() internal view returns (YesNo) {
        require(checkThreshold());
        if (votes[Outcome.Yes] > votes[Outcome.No] && votes[Outcome.Yes] > votes[Outcome.Indet]){
            return yesToken;
        }
        else if (votes[Outcome.No] > votes[Outcome.Yes] && votes[Outcome.No] > votes[Outcome.Indet]){
            return noToken;
        }
        else {
            return indetToken;
        }
    }

    function redeem(uint256 amt) public decided {
        YesNo winner = decideOutcome();
        require(winner.allowance(msg.sender, address(this)) > amt);
        winner.transferFrom(msg.sender, address(this), amt);
        payment.transfer(msg.sender, amt);
    }

    function seeVotes() public view returns(uint256, uint256, uint256){
        return (votes[Outcome.Yes], votes[Outcome.No], votes[Outcome.Indet]);
    }
}
