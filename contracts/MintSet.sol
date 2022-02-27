// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

interface YesNo {
        function transferFrom(address from, address to, uint256 amount) external returns (bool);
        function transfer(address recipient, uint256 amount) external returns (bool);
        function allowance(address owner, address spender) external returns (uint256);
        function mint(address addr, uint256 amt) external;
    }

interface Payment {
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external returns (uint256);
}

contract MintSet is Ownable{
    YesNo public yesToken;
    YesNo public noToken;
    YesNo public indetToken;
    Payment public payment;
    address redeemer;

    constructor(address _payment, address _yesToken, address _noToken, address _indetToken){
        yesToken = YesNo(_yesToken);
        noToken = YesNo(_noToken);
        indetToken = YesNo(_indetToken);
        payment = Payment(_payment);
    }

    function setRedeemer(address addr) public onlyOwner{
        redeemer = addr;
    }

    function mintSet(uint256 amt) public {
        require(payment.allowance(msg.sender, address(this)) > amt);
        payment.transferFrom(msg.sender, redeemer, amt);
        yesToken.mint(msg.sender, amt);
        noToken.mint(msg.sender, amt);
        indetToken.mint(msg.sender, amt);
    }

    function viewTokens() public view returns(YesNo, YesNo, YesNo){
        return (yesToken, noToken, indetToken);
    }

    function viewPayment() public view returns(Payment){
        return payment;
    }
}
