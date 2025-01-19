// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {IERC20} from "../interfaces/IERC20.sol";
import {IPool} from "../interfaces/IPool.sol";
import {IVariableDebtToken} from "../interfaces/IVariableDebtToken.sol";
import {POOL} from "../Constants.sol";

contract Repay {
    IPool private constant pool = IPool(POOL);

    // TODO: supply + borrow

    function repay(address token, uint256 amount) external {
        IPool.ReserveData memory reserve = pool.getReserveData(token);
        IVariableDebtToken debtToken =
            IVariableDebtToken(reserve.variableDebtTokenAddress);
        debtToken.approveDelegation(msg.sender, type(uint256).max);

        uint256 debt = debtToken.balanceOf(address(this));

        IERC20(token).transferFrom(msg.sender, address(this), debt);
        IERC20(token).approve(address(pool), debt);

        pool.repay({
            asset: token,
            amount: debt,
            interestRateMode: 2,
            onBehalfOf: address(this)
        });
    }
}
