// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract No is ERC20 {
    address owner;

    constructor (string memory name, string memory symbol) ERC20(name, symbol) {
        owner = msg.sender;
    }

    modifier onlyMinter(){
        require(msg.sender == owner);
        _;
    }

    function changeOwner(address addr) public onlyMinter {
        owner = addr;
    }

    function mint(address addr, uint256 amt) public {
        _mint(addr, amt);
    }
}
