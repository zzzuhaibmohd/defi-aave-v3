// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {IPool} from "../interfaces/aave-v3/IPool.sol";
import {POOL} from "../Constants.sol";

abstract contract Aave {
    IPool public constant pool = IPool(POOL);

    function supply(address token, uint256 amount, address onBehalfOf) public {
        pool.supply({
            asset: token,
            amount: amount,
            onBehalfOf: onBehalfOf,
            referralCode: 0
        });
    }

    function borrow(address token, uint256 amount, address onBehalfOf) public {
        pool.borrow({
            asset: token,
            amount: amount,
            // 1 = Stable interest rate
            // 2 = Variable interest rate
            interestRateMode: 2,
            referralCode: 0,
            onBehalfOf: onBehalfOf
        });
    }

    function repay(address token, uint256 amount, address onBehalfOf)
        public
        returns (uint256 repaid)
    {
        return pool.repay({
            asset: token,
            amount: amount,
            interestRateMode: 2,
            onBehalfOf: onBehalfOf
        });
    }

    function withdraw(address token, uint256 amount, address to)
        public
        returns (uint256 withdrawn)
    {
        return pool.withdraw({asset: token, amount: amount, to: to});
    }

    function getHealthFactor(address user) public view returns (uint256) {
        (,,,,, uint256 healthFactor) = pool.getUserAccountData(user);
        return healthFactor;
    }
}
