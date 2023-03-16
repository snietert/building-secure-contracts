// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.5.3;

import "token.sol";

/// @dev to run: $ echidna-test solution.sol
contract TestToken is Token {
    constructor() public {
        paused();
        owner = address(0x0); // lose ownership
    }

    // add the property
    function echidna_no_transfer() public view returns (bool) {
        return is_paused == true;
    }
}
