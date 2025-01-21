// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {IERC20, IERC20Metadata} from "../interfaces/IERC20.sol";
import {IPool} from "../interfaces/IPool.sol";
import {IAaveOracle} from "../interfaces/IAaveOracle.sol";
import {POOL, ORACLE} from "../Constants.sol";

contract Borrow {
    IPool private constant pool = IPool(POOL);
    IAaveOracle private constant oracle = IAaveOracle(ORACLE);

    function supply(address token, uint256 amount) external {
        IERC20(token).transferFrom(msg.sender, address(this), amount);
        IERC20(token).approve(address(pool), amount);
        pool.supply({
            asset: token,
            amount: amount,
            onBehalfOf: address(this),
            referralCode: 0
        });
    }

    function approxMaxBorrow(address token) external view returns (uint256) {
        // 1e8 = 1 USD
        uint256 price = oracle.getAssetPrice(token);
        uint256 decimals = IERC20Metadata(token).decimals();

        (,, uint256 availableToBorrowUsd,,,) =
            pool.getUserAccountData(address(this));

        return availableToBorrowUsd * (10 ** decimals) / price;
    }

    function getHealthFactor() external view returns (uint256) {
        (,,,,, uint256 healthFactor) = pool.getUserAccountData(address(this));
        return healthFactor;
    }

    function getVariableDebt(address token) external view returns (uint256) {
        IPool.ReserveData memory reserve = pool.getReserveData(token);
        return IERC20(reserve.variableDebtTokenAddress).balanceOf(address(this));
    }

    function borrow(address token, uint256 amount) external {
        pool.borrow({
            asset: token,
            amount: amount,
            // 1 = Stable interest rate
            // 2 = Variable interest rate
            interestRateMode: 2,
            referralCode: 0,
            onBehalfOf: address(this)
        });
    }
}
