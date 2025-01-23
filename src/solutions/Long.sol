// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {IERC20} from "../interfaces/IERC20.sol";
import {IPool} from "../interfaces/aave-v3/IPool.sol";
import {Aave} from "../lib/Aave.sol";
import {Swap} from "../lib/Swap.sol";
import {POOL} from "../Constants.sol";

contract Long is Aave, Swap {
    function long(
        address collateralToken,
        uint256 collateralAmount,
        address borrowToken,
        uint256 borrowAmount,
        uint256 minHealthFactor,
        uint256 minSwapAmountOut,
        bytes memory swapData
    ) public returns (uint256 collateralAmountOut) {
        require(minHealthFactor > 1e18, "min health factor <= 1");
        // Approve this contract to pull in collateral
        // Approve this contract to borrow

        // Transfer collateral
        IERC20(collateralToken).transferFrom(
            msg.sender, address(this), collateralAmount
        );

        // Supply collateral
        IERC20(collateralToken).approve(address(pool), collateralAmount);
        supply(collateralToken, collateralAmount, msg.sender);

        // Borrow token
        borrow(borrowToken, borrowAmount, msg.sender);

        // Check health factor
        require(
            getHealthFactor(msg.sender) >= minHealthFactor,
            "health factor < min"
        );

        // Swap borrow token to collateral token
        IERC20(borrowToken).approve(address(router), borrowAmount);
        return swap({
            tokenIn: borrowToken,
            tokenOut: collateralToken,
            amountIn: borrowAmount,
            amountOutMin: minSwapAmountOut,
            receiver: msg.sender,
            data: swapData
        });
    }

    function close(
        address collateralToken,
        uint256 collateralAmount,
        address borrowToken,
        uint256 minSwapAmountOut
    ) public {
        // Approve this contract to pull in collateral

        // Transfer collateral
        // Swap collateral to borrow
        // Repay borrow
        // Withdraw collateral
        // Transfer profit = swapped - repaid to msg.sender
        // Transfer collateral to msg.sender
    }
}
