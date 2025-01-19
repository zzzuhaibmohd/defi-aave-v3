// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {IERC20} from "../interfaces/IERC20.sol";
import {IPool} from "../interfaces/IPool.sol";
import {POOL} from "../Constants.sol";

contract Supply {
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

    function getSupplyBalance(address token) external view returns (uint256) {
        IPool.ReserveData memory reserve = pool.getReserveData(token);
        return IERC20(reserve.aTokenAddress).balanceOf(address(this));
    }
}
