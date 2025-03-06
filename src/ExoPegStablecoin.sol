// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

/*
 * @title ExoPegStablecoin
 * @dev This contract is a ERC20 token that can be minted and burned by the EPDEngine smart contract.
 */
contract ExoPegStablecoin is ERC20, Ownable {
    error ExoPegStablecoin__AmountMustBeMoreThanZero();
    error ExoPegStablecoin__BurnAmountExceedsBalance();

    modifier notZero(uint256 _amount) {
        if (_amount <= 0) revert ExoPegStablecoin__AmountMustBeMoreThanZero();
        _;
    }

    constructor(address _initialOwner) ERC20("ExoPeg Dollar", "EPD") Ownable(_initialOwner) {}

    function mint(address _to, uint256 _amount) public notZero(_amount) onlyOwner returns (bool) {
        _mint(_to, _amount); // Mint the amount of tokens to the recipient
        return true;
    }

    function burn(uint256 _amount) public notZero(_amount) onlyOwner {
        if (_amount > balanceOf(owner())) revert ExoPegStablecoin__BurnAmountExceedsBalance();

        _burn(owner(), _amount); // Burn the amount of tokens from the owner
    }
}
