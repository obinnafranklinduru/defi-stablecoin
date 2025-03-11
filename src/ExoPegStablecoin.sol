// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { ERC20Burnable, ERC20 } from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

/*
 * @title ExoPegStablecoin
 * @dev This contract is a ERC20 token that can be minted and burned by the EPDEngine smart contract.
 */
contract ExoPegStablecoin is ERC20Burnable, Ownable {
    error ExoPegStablecoin__AmountMustBeMoreThanZero();
    error ExoPegStablecoin__BurnAmountExceedsBalance();
    error ExoPegStablecoin__NotZeroAddress();

    modifier notZero(uint256 _amount) {
        if (_amount <= 0) revert ExoPegStablecoin__AmountMustBeMoreThanZero();
        _;
    }

    constructor(address _initialOwner) ERC20("ExoPeg Dollar", "EPD") Ownable(_initialOwner) {}

    function mint(address _to, uint256 _amount) public notZero(_amount) onlyOwner returns (bool) {
        if(_to == address(0)) revert ExoPegStablecoin__NotZeroAddress();
        _mint(_to, _amount); // Mint the amount of tokens to the recipient
        return true;
    }

    function burn(uint256 _amount) public override notZero(_amount) onlyOwner {
        if (_amount > balanceOf(owner())) revert ExoPegStablecoin__BurnAmountExceedsBalance();

        super.burn(_amount); // Burn the amount of tokens from the owner
    }
}
