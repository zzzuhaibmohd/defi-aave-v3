// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {IERC20} from "../interfaces/IERC20.sol";
import {IPool} from "../interfaces/IPool.sol";
import {POOL} from "../Constants.sol";

contract Borrow {
    IPool private constant pool = IPool(POOL);

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

    // TODO:
    function calcMaxBorrow(address token) public view returns (uint256) {
        /*
        (,, uint256 availableToBorrowUsd,,,) =
            pool.getUserAccountData(address(this));

        uint256 amount = availableToBorrowUsd * 1e10 * 99 / 100;
        */
    }

    function borrow(address token, uint256 amount) external {
        require(amount <= calcMaxBorrow(token), "amount > max");
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
