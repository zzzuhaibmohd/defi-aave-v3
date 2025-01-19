// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {IERC20} from "../interfaces/IERC20.sol";
import {IPool} from "../interfaces/IPool.sol";
import {POOL} from "../Constants.sol";

contract Withdraw {
    IPool private constant pool = IPool(POOL);

    function withdraw(address token, uint256 amount) external {
        IPool.ReserveData memory reserve = pool.getReserveData(token);
        IERC20 aToken = IERC20(reserve.aTokenAddress);
        // TODO: use full balance in exercise somehow
        uint256 bal = aToken.balanceOf(address(this));

        pool.withdraw({asset: token, amount: amount, to: address(this)});
    }
}
