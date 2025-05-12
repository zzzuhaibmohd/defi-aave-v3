# DeFi Aave V3 (3.3)

### TODO

- natspec
- exercise instructions
  - don't use in production (tokens are locked)
- NOTE: all exercise funcs are public

```shell
# Install
forge build
cp .env.sample .env

# Test
FORK_URL=...
forge test --fork-url $FORK_URL --match-path test/Supply.test.sol -vvv
```

- Setup

  - aave v3.3
  - Tenderly + transaction links
  - How to solve exercises (show demo of tenderly)

- Intro
  - [ ] UI
    - supply
      - send tx
        - health factor
        - stats
        - withdraw
      - detail
        - reserve size
        - available liquidity
        - utilization rate
        - APY and APR
        - collateral
          - max ltv
          - liquidation threshold and penalty
        - interest rate model
          - utilization rate
          - borrow interest
      - isolation mode (TODO: fix restriction on collateral explanation)
    - borrow
      - health factor
      - risk details
      - details
        - reserve factor
        - e-mode
          - E-Mode increases your LTV for a selected category of assets.
          - enable emode
      - repay
- Core concepts - [x] [APY and APR](./notes/apr-apy.png)
  - [x] [Market forces](./notes/market-forces.png)
  - [x] [Utilization rate](./notes/utilization-rate.png)
  - [x] [Interest rate model - graph](https://www.desmos.com/calculator/2pfuulkndt)
    - [`DefaultReserveInterestRateStrategyV2.calculateInterestRates`](https://github.com/aave-dao/aave-v3-origin/blob/5431379f8beb4d7128c84a81ced3917d856efa84/src/contracts/misc/DefaultReserveInterestRateStrategyV2.sol#L125-L177)
  - [x] [Reserve](./notes/reserve.md)
  - [x] AToken and debt token
    - [Supply DAI](https://etherscan.io/tx/0x48237c5e7aaae5d35f36c1d8b66abf4cc5fc8d335dfa395f89b3b1627a2540c8)
    - [Borrow ETH](https://etherscan.io/tx/0xfe4b17b089b50bf9c2b00561061b4205e72bf9695c63e7fde31d54f299b9392f)
  - [ ] Liquidity and borrow index animation
  - [x] [Scaled balance](./notes/scaled-balance.png)
    - [Code](https://github.com/aave-dao/aave-v3-origin/blob/5431379f8beb4d7128c84a81ced3917d856efa84/src/contracts/protocol/tokenization/base/ScaledBalanceTokenBase.sol#L66-L120)
  - [x] [Liquidity and borrow indexes code](./notes/liquidity-index.md)
    - [ ] TODO:? Why linear and compound interest?
      - risk compensation -> strong incentive for borrowers to repay
      - protocol revenue -> interest rate spread (graph)
- Contract architecture
  - [x] [Contract architecture](./notes/arc.png)
  - Supply
    - [x] Execution flow (tenderly)
      - on behalf of
    - [ ] linear interest
      - `MathUtils.calculateLinearInterest`
    - [x] Exercise
  - Borrow
    - [x] Execution flow (tenderly)
      - credit delegation
    - [ ] compound interest
      - Why supply is linear and borrow is compound?
      - TODO: [python approximation](./notes/binomial_expansion.ipynb)
        - `MathUtils.calculateCompoundedInterest` (TODO: animation?)
    - [x] [Reserve factor](./notes/reserve-factor.md)
    - [x] [LTV](./notes/ltv.png)
    - [x] [Liquidation threshold](./notes/liquidation-threshold.png)
    - [x] [Health factor](./notes/health-factor.png)
      - [Code](https://github.com/aave-dao/aave-v3-origin/blob/5431379f8beb4d7128c84a81ced3917d856efa84/src/contracts/protocol/libraries/logic/GenericLogic.sol#L63-L183)
    - [x] Exercise
  - Repay
    - [x] Execution flow (tenderly)
    - [x] Exercise
  - Withdraw
    - [x] Execution flow (tenderly)
      - Conditions for withdraw (health factor)
    - [x] Exercise
  - Liquidation
    - [ ] Execution flow (tenderly)?
    - [x] [Close factor](./notes/close-factor.png)
      - [Code](./notes/liquidation.md)
      - `MIN_LEFTOVER_BASE`
    - [x] [Math](./notes/liquidation.png)
      - condition
      - amount of collateral to liquidate
      - bonus
      - protocol fee
      - [ ] [Code](./notes/liquidation.md)
    - [ ] TODO: dust?
    - [x] Exercise
  - Flash loan simple
    - [x] [Execution flow](./notes/flash-loan.md)
    - [ ] Exercise
- Long leverage and short
  - [ ] [Long leverage](./notes/long.png)
  - [ ] [Short](./notes/short.png)
  - [ ] Flash leverage
  - [ ] Exercises

### Resources

##### Aave V3

- [App](https://app.aave.com/)
- [Docs](https://aave.com/docs)
- [GitHub aave-v3-origin](https://github.com/aave-dao/aave-v3-origin)
- [GitHub aave-v3-origin 3.3](https://github.com/aave-dao/aave-v3-origin/tree/v3.3.0)
- [GitHub aave v3 error codes](https://github.com/aave/aave-v3-core/blob/master/contracts/protocol/libraries/helpers/Errors.sol)
- [Aave V3 book](https://calnix.gitbook.io/aave-book)
- [Pool - proxy](https://etherscan.io/address/0x87870Bca3F3fD6335C3F4ce8392D69350B4fA4E2)

##### Transactions

- [Supply rETH tx](https://etherscan.io/tx/0xc1120138b3aa3dc6a49ef7e84ecd17530c273e2442f83e47025d819d9a700743)
- [Supply ETH tx](https://etherscan.io/tx/0x21de14e5c58b9431a70b780893d01f0b82f07a0495d851d97fc0e85c64887610)
- [Borrow DAI tx](https://etherscan.io/tx/0x5e4deab9462bec720f883522d306ec306959cb3ae1ec2eaf0d55477eed01b5a4)
- [Repay DAI tx](https://etherscan.io/tx/0x1145e9815060164ef9234bdbc6d88db97ac5dda7b1e30732dc981145604e0373)
- [Withdraw rETH](https://etherscan.io/tx/0x7442ab56bfe90a189516f44846b93d25aa0dde3bbfba935429ac561ab34bc575)
- [Withdraw ETH](https://etherscan.io/tx/0x748e56cfaa10b6d629bd06badfdf83b337956e640523bbb1805901e11915c517)
- [Supply DAI](https://etherscan.io/tx/0x48237c5e7aaae5d35f36c1d8b66abf4cc5fc8d335dfa395f89b3b1627a2540c8)
- [Withdraw DAI](https://etherscan.io/tx/0x4e263e358db180ec478d61542a1126a47bba6d6fc0d5bb2b7b8cf83a8bdb11d3)
- [Borrow DAI](https://etherscan.io/tx/0x5e4deab9462bec720f883522d306ec306959cb3ae1ec2eaf0d55477eed01b5a4)
- [Repay DAI](https://etherscan.io/tx/0x1145e9815060164ef9234bdbc6d88db97ac5dda7b1e30732dc981145604e0373)
- [Borrow ETH](https://etherscan.io/tx/0xfe4b17b089b50bf9c2b00561061b4205e72bf9695c63e7fde31d54f299b9392f)

##### Misc

- [DeFiLama Swap](https://swap.defillama.com/)
