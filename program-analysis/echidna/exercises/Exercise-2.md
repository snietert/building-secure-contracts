# Exercise 2

This exercise requires to finish the [exercise 1](Exercise-1.md).

**Table of contents:**

- [Exercise 2](#exercise-2)
  - [Targeted contract](#targeted-contract)
  - [Testing access control](#testing-access-control)
    - [Goals](#goals)
  - [Solution](#solution)

Join the team on Slack at: https://empireslacking.herokuapp.com/ #ethereum

## Targeted contract

We will test the following contract _[token.sol](https://github.com/crytic/building-secure-contracts/tree/master/program-analysis/echidna/exercises/exercise2/token.sol)_:

```solidity
pragma solidity ^0.5.0;

contract Ownable {
    address public owner = msg.sender;

    function Owner() public {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(owner == msg.sender);
        _;
    }
}

contract Pausable is Ownable {
    bool private _paused;

    function paused() public view returns (bool) {
        return _paused;
    }

    function pause() public onlyOwner {
        _paused = true;
    }

    function resume() public onlyOwner {
        _paused = false;
    }

    modifier whenNotPaused() {
        require(!_paused, "Pausable: Contract is paused.");
        _;
    }
}

contract Token is Ownable, Pausable {
    mapping(address => uint256) public balances;

    function transfer(address to, uint256 value) public whenNotPaused {
        balances[msg.sender] -= value;
        balances[to] += value;
    }
}
```

## Testing access control

### Goals

- Consider `pause()` to be called at deployment, and the ownership removed.
- Add a property to check that the contract cannot be unpaused.
- Once Echidna finds the bug, fix the issue, and re-try your property with Echidna.

The skeleton for this exercise is (_[template.sol](https://github.com/crytic/building-secure-contracts/tree/master/program-analysis/echidna/exercises/exercise2/template.sol)_):

````solidity
pragma solidity ^0.5.0;

import "./token.sol";

/// @dev Run the template with
///      ```
///      solc-select use 0.5.0
///      echidna program-analysis/echidna/exercises/exercise2/template.sol
///      ```
contract TestToken is Token {
    constructor() public {
        pause(); // pause the contract
        owner = address(0); // lose ownership
    }

    function echidna_cannot_be_unpause() public view returns (bool) {
        // TODO: add the property
    }
}
````

## Solution

This solution can be found in [solution.sol](https://github.com/crytic/building-secure-contracts/tree/master/program-analysis/echidna/exercises/exercise2/solution.sol)
