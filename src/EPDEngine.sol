// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {ReentrancyGuard} from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import { ExoPegStablecoin } from "./ExoPegStablecoin.sol";


/*
 * @title EPDEngine
 * @notice Core contract for ExoPegStablecoin, a DeFi stablecoin pegged 1:1 to a fiat currency (the US Dollar).
 * @description It manages the minting and redemption of EPD tokens, along with collateral deposit and withdrawal operations.
 * 
 * @dev Inspired by MakerDAO's DSS system, this minimal engine focuses on essential functions to ensure stability and simplicity.
 */
contract EPDEngine is ReentrancyGuard  {
    error EPDEngine__CollateralAmountMustBeMoreThanZero();
    error EPDEngine__InvalidTokenAddress();

    modifier notZero(uint256 _amount){
        if (_amount <= 0) revert EPDEngine__CollateralAmountMustBeMoreThanZero();
        _;
    }

    modifier isAllowedTokens(address _token) {
        if (_token != address(0)) revert EPDEngine__InvalidTokenAddress();
        _;
    }

    function depositCollateralAndMintEPD() external {}

    function depositCollateral() external {}

    function redeemCollateralForEPD() external {}

    function redeemCollateral() external {}

    function mintEPD() external {}

    function burnEPD() external {}

    function liquidate() external {}

    function getHealthFactor() external view {}

}