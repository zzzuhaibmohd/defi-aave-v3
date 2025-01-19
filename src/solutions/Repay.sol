// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {IERC20} from "../interfaces/IERC20.sol";
import {IPool} from "../interfaces/IPool.sol";
import {IVariableDebtToken} from "../interfaces/IVariableDebtToken.sol";
import {POOL} from "../Constants.sol";

contract Repay {
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

    function borrow(address token, uint256 amount) external {
        // TODO:  keep token in this contract?
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

    function calcRepayAmount(address token) public view returns (uint256) {
        IPool.ReserveData memory reserve = pool.getReserveData(token);
        IVariableDebtToken debtToken =
            IVariableDebtToken(reserve.variableDebtTokenAddress);
        return debtToken.balanceOf(address(this));
    }

    function repay(address token, uint256 amount) external {
        // TODO: transfer the difference (debt - balance in this contract)?
        IERC20(token).transferFrom(msg.sender, address(this), amount);
        IERC20(token).approve(address(pool), amount);

        pool.repay({
            asset: token,
            amount: amount,
            interestRateMode: 2,
            onBehalfOf: address(this)
        });
    }
}
