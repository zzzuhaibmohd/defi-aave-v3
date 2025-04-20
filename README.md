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
  - Tenderly
  - How to solve exercises (show demo of tenderly)

- Intro
  - [ ] UI
    - use case
    - supply
      - APY and APR
      - interest rate model
        - utilization rate
      - isolated mode
        - Isolated assets have limited borrowing power and other assets cannot be used as collateral.
    - borrow
      - ltv
      - health factor
      - liquidation penalty, bonus, close factor
      - e-mode
        - E-Mode increases your LTV for a selected category of assets.
    - net apy
    - repay
    - withdraw
- Core concepts
  - [ ] [APY and APR](./notes/apr-apy.png)
  - [ ] [Market forces](./notes/market-forces.png)
  - [ ] [Utilization rate](./notes/utilization-rate.png)
  - [ ] [Interest rate model - graph](https://www.desmos.com/calculator/2pfuulkndt)
    - [`DefaultReserveInterestRateStrategyV2.calculateInterestRates`](https://github.com/aave-dao/aave-v3-origin/blob/5431379f8beb4d7128c84a81ced3917d856efa84/src/contracts/misc/DefaultReserveInterestRateStrategyV2.sol#L125-L177)
  - [ ] Reserve (move to supply section?)
  - [ ] AToken and debt token (UI)
    - rebase token
    - 1:1
  - [ ] Liquidity and borrow index -> animation?
  - [ ] [Scaled balance](./notes/scaled-balance.png)
    - [Code](https://github.com/aave-dao/aave-v3-origin/blob/5431379f8beb4d7128c84a81ced3917d856efa84/src/contracts/protocol/tokenization/base/ScaledBalanceTokenBase.sol#L66-L120)
  - [ ] [Liquidity and borrow indexes code](./notes/liquidity-index.md)
    - [ ] Why linear and compound interest?
      - risk compensation -> strong incentive for borrowers to repay
      - protocol revenue -> interest rate spread (graph)
- Contract architecture
  - [Contract architecture](./notes/arc.png)
  - Supply
    - [ ] Execution flow (tenderly)
    - [ ] linear interest
    - [ ] on behalf of
    - [x] Exercise
  - Borrow
    - [ ] Execution flow (tenderly)
    - [ ] compound interest
      - why supply -> linear and borrow -> compound -> protocol safety
    - [ ] reserve factor
      - protocol fee rate
      - risky asset -> high reserve factor
      - low risk asset -> low reserve factor
    - [ ] ltv
    - [ ] liquidation threshold
    - [ ] health factor
      - [Code](https://github.com/aave-dao/aave-v3-origin/blob/5431379f8beb4d7128c84a81ced3917d856efa84/src/contracts/protocol/libraries/logic/GenericLogic.sol#L63-L183)
    - [ ] TODO: Emode here?
    - [ ] credit delegation
    - [x] Exercise
  - Repay
    - [ ] Execution flow (tenderly)
    - [x] Exercise
  - Withdraw
    - [ ] Execution flow (tenderly)
    - [ ] Conditions for withdraw (health factor)
    - [ ] Exercise
  - Liquidation
    - [ ] Execution flow (tenderly)?
    - [ ] [Close factor](./notes/close-factor.png)
      - [Code](./notes/liquidation.md)
      - `MIN_LEFTOVER_BASE`
    - [ ] [Math](./notes/liquidation.png)
      - condition
      - amount of collateral to liquidate
      - bonus
      - protocol fee
    - [ ] [Code](./notes/liquidation.md)
    - [x] Exercise
  - Flash loan simple
    - [ ] Execution flow
    - [ ] Exercise
- Leverage and short
  - [ ] Leverage
  - [ ] Short
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

TODO: send new transactions?

- [Supply rETH tx](https://etherscan.io/tx/0xc1120138b3aa3dc6a49ef7e84ecd17530c273e2442f83e47025d819d9a700743)
- [Supply ETH tx](https://etherscan.io/tx/0x21de14e5c58b9431a70b780893d01f0b82f07a0495d851d97fc0e85c64887610)
- [Borrow DAI tx](https://etherscan.io/tx/0x5e4deab9462bec720f883522d306ec306959cb3ae1ec2eaf0d55477eed01b5a4)
- [Repay DAI tx](https://etherscan.io/tx/0x1145e9815060164ef9234bdbc6d88db97ac5dda7b1e30732dc981145604e0373)
- [Withdraw rETH](https://etherscan.io/tx/0x7442ab56bfe90a189516f44846b93d25aa0dde3bbfba935429ac561ab34bc575)
- [Withdraw ETH](https://etherscan.io/tx/0x748e56cfaa10b6d629bd06badfdf83b337956e640523bbb1805901e11915c517)

- [Borrow ETH - waiting for liquidation](https://etherscan.io/tx/0xfe4b17b089b50bf9c2b00561061b4205e72bf9695c63e7fde31d54f299b9392f)

##### Misc

- [DeFiLama Swap](https://swap.defillama.com/)
