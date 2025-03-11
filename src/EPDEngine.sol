// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {ReentrancyGuard} from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {ExoPegStablecoin} from "./ExoPegStablecoin.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/*
 * @title EPDEngine
 * @notice Core contract for ExoPegStablecoin, a DeFi stablecoin pegged 1:1 to a fiat currency (the US Dollar).
 * @description It manages the minting and redemption of EPD tokens, along with collateral deposit and withdrawal operations.
 * 
 * @dev Inspired by MakerDAO's DSS system, this minimal engine focuses on essential functions to ensure stability and simplicity.
 */
contract EPDEngine is ReentrancyGuard {
    error EPDEngine__CollateralAmountMustBeMoreThanZero();
    error EPDEngine__InvalidTokenAddress();
    error EPDEngine__TransferFailed();
    error EPDEngine__TokenAddressesAndPriceFeedsLengthMismatch();

    ExoPegStablecoin private immutable EPD;

    mapping(address token => address priceFeed) private priceFeeds;
    mapping(address user => mapping(address token => uint256 amount)) private collateralDeposited;
    mapping(address user => uint256 amountEPDMinted) private EPDMinted;  

    event CollateralDeposited(address indexed user, address indexed token, uint256 amount);

    modifier notZero(uint256 _amount) {
        if (_amount <= 0) revert EPDEngine__CollateralAmountMustBeMoreThanZero();
        _;
    }

    modifier isAllowedTokens(address _token) {
        if (priceFeeds[_token] == address(0)) revert EPDEngine__InvalidTokenAddress();
        _;
    }

    constructor(address[] memory _tokenAddresses, address[] memory _priceFeedAddresses, address _EPDAddress) {
        if (_tokenAddresses.length != _priceFeedAddresses.length) {
            revert EPDEngine__TokenAddressesAndPriceFeedsLengthMismatch();
        }

        for (uint256 i = 0; i < _tokenAddresses.length; i++) {
            priceFeeds[_tokenAddresses[i]] = _priceFeedAddresses[i];
        }
        EPD = ExoPegStablecoin(_EPDAddress);
    }

    function depositCollateralAndMintEPD() external {}

    /**
     * @param _tokenCollateralAddress The address of the token to deposit as collateral
     * @param _amountCollateral The amount of collateral to deposit
     */
    function depositCollateral(address _tokenCollateralAddress, uint256 _amountCollateral)
        external
        isAllowedTokens(_tokenCollateralAddress)
        notZero(_amountCollateral)
        nonReentrant
    {
        collateralDeposited[msg.sender][_tokenCollateralAddress] += _amountCollateral;
        emit CollateralDeposited(msg.sender, _tokenCollateralAddress, _amountCollateral);

        bool success = IERC20(_tokenCollateralAddress).transferFrom(msg.sender, address(this), _amountCollateral);
        if(!success) revert EPDEngine__TransferFailed();
    }

    function redeemCollateralForEPD() external {}

    function redeemCollateral() external {}

    /**
     * @param _amountEPDToMint The amount of EPD tokens to mint
     * @notice User must have more collateral value than the minimum threshold
     */
    function mintEPD(uint256 _amountEPDToMint) external notZero(_amountEPDToMint) {
        EPDMinted[msg.sender] += _amountEPDToMint;
    }

    function burnEPD() external {}

    function liquidate() external {}

    function getHealthFactor() external view {}

    function _healthFactor(address user) private view returns(uint256) {
        // Calculate the health factor of the user
        // Health factor = (collateralValue * collateralRatio) / EPDValue
        // Collateral value = sum of all collateral values in USD
        // EPD value = sum of all EPD values in USD
        // Collateral ratio = 150%
    }

    function _revertIfHealthFactorIsBroken(address _user) internal view {
        // Check if health factor is below the threshold
        // If it is, revert the transaction


    }
}
