// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {Test, console} from "forge-std/Test.sol";
import {IERC20} from "@src/interfaces/IERC20.sol";
import {POOL, ORACLE, WETH, DAI} from "@src/Constants.sol";
import {IPool} from "@src/interfaces/IPool.sol";
import {IAaveOracle} from "@src/interfaces/IAaveOracle.sol";
// TODO: exercises path
import {Borrow} from "@src/solutions/Borrow.sol";

// forge test --fork-url $FORK_URL --match-path test/Borrow.test.sol -vvv

contract BorrowTest is Test {
    IERC20 private constant weth = IERC20(WETH);
    IERC20 private constant dai = IERC20(DAI);
    IPool private constant pool = IPool(POOL);
    IAaveOracle private constant oracle = IAaveOracle(ORACLE);
    IERC20 private debtToken;
    Borrow private target;

    function setUp() public {
        deal(WETH, address(this), 1e18);
        target = new Borrow();

        IPool.ReserveData memory reserve = pool.getReserveData(DAI);
        debtToken = IERC20(reserve.variableDebtTokenAddress);

        weth.approve(address(target), 1e18);
        target.supply(WETH, 1e18);
    }

    function test_borrow() public {
        uint256 wethPrice = oracle.getAssetPrice(WETH);
        uint256 approxMaxBorrow = target.approxMaxBorrow(DAI);
        uint256 hf = target.getHealthFactor();

        console.log("WETH price: %e", wethPrice);
        console.log("Approximate max borrow: %e", approxMaxBorrow);
        console.log("Health factor: %e", hf);

        assertGt(hf, 0);
        assertGt(approxMaxBorrow, 0);
        assertEq(target.getVariableDebt(DAI), 0);

        target.borrow(DAI, 100 * 1e18);

        uint256 bal = dai.balanceOf(address(target));
        uint256 debt = debtToken.balanceOf(address(target));

        console.log("DAI balance: %e", bal);
        console.log("DAI debt: %e", debt);

        assertEq(bal, 100 * 1e18);
        assertGe(debt, bal);
        assertEq(target.getVariableDebt(DAI), debt);
    }
}
