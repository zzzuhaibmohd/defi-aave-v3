// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {Test, console} from "forge-std/Test.sol";
import {IERC20} from "@src/interfaces/IERC20.sol";
import {
    POOL,
    ORACLE,
    WETH,
    DAI,
    UNISWAP_V3_POOL_FEE_DAI_WETH
} from "@src/Constants.sol";
import {IPool} from "@src/interfaces/aave-v3/IPool.sol";
import {IVariableDebtToken} from
    "@src/interfaces/aave-v3/IVariableDebtToken.sol";
import {IAaveOracle} from "@src/interfaces/aave-v3/IAaveOracle.sol";
// TODO: exercises path
import {Long} from "@src/solutions/Long.sol";

// forge test --fork-url $FORK_URL --match-path test/Long.test.sol -vvv

contract LongTest is Test {
    IERC20 private constant weth = IERC20(WETH);
    IERC20 private constant dai = IERC20(DAI);
    IPool private constant pool = IPool(POOL);
    IAaveOracle private constant oracle = IAaveOracle(ORACLE);
    Long private target;

    function setUp() public {
        deal(WETH, address(this), 1e18);
        target = new Long();
    }

    function test_open_and_close() public {
        IPool.ReserveData memory debtReserve = pool.getReserveData(DAI);

        // Test open
        console.log("--- open ---");
        IVariableDebtToken debtToken =
            IVariableDebtToken(debtReserve.variableDebtTokenAddress);
        debtToken.approveDelegation(address(target), type(uint256).max);

        weth.approve(address(target), type(uint256).max);

        uint256 collateralAmount = 1e18;
        uint256 borrowAmount = 1000 * 1e18;

        bytes memory swapData = abi.encode(UNISWAP_V3_POOL_FEE_DAI_WETH);

        uint256 collateralAmountOut = target.open(
            Long.OpenParams({
                collateralToken: WETH,
                collateralAmount: collateralAmount,
                borrowToken: DAI,
                borrowAmount: borrowAmount,
                minHealthFactor: 1.5 * 1e18,
                minSwapAmountOut: 1,
                swapData: swapData
            })
        );

        console.log("Collateral amount out: %e", collateralAmountOut);
        assertGt(collateralAmountOut, 0, "collateral amount out = 0");
        assertEq(
            weth.balanceOf(address(this)),
            collateralAmountOut,
            "WETH balance of this contract"
        );
        assertEq(weth.balanceOf(address(target)), 0, "WETH balance of target");

        // Test close
        console.log("--- Close ---");
        IPool.ReserveData memory collateralReserve = pool.getReserveData(WETH);
        IERC20 aToken = IERC20(collateralReserve.aTokenAddress);
        aToken.approve(address(target), type(uint256).max);

        deal(DAI, address(this), 100 * 1e18);
        dai.approve(address(target), 100 * 1e18);

        uint256 wethBal = weth.balanceOf(address(this));
        weth.approve(address(target), wethBal);

        uint256[2] memory balsBefore =
            [weth.balanceOf(address(this)), dai.balanceOf(address(this))];

        (
            uint256 collateralWithdrawn,
            uint256 debtRepaidFromMsgSender,
            uint256 borrowedLeftover
        ) = target.close(
            Long.CloseParams({
                collateralToken: WETH,
                collateralAmount: wethBal,
                maxCollateralToWithdraw: type(uint256).max,
                borrowToken: DAI,
                maxDebtToRepay: type(uint256).max,
                minSwapAmountOut: 1,
                swapData: swapData
            })
        );

        uint256[2] memory balsAfter =
            [weth.balanceOf(address(this)), dai.balanceOf(address(this))];

        console.log("Collateral withdrawn: %e", collateralWithdrawn);
        console.log("Debt repaid from msg.sender : %e", debtRepaidFromMsgSender);
        console.log("Borrowed leftover: %e", borrowedLeftover);

        assertGe(balsAfter[0], collateralAmount, "WETH balance");
        assertGe(collateralWithdrawn, collateralAmount, "WETH withdrawn");
        assertEq(
            balsAfter[1],
            balsBefore[1] - debtRepaidFromMsgSender + borrowedLeftover,
            "DAI balance"
        );
    }
}
