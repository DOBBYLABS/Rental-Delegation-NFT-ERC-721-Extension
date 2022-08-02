// SPDX-License-Identifier: CC0-1.0

pragma solidity ^0.8.0; 

import "../ERCX.sol";

contract ERCXTest is ERCX {

    constructor(string memory name_, string memory symbol_) ERCX(name_,symbol_) {}

    function mint(uint256 tokenId, address to) public {
        _mint(to, tokenId);
    }
} 
