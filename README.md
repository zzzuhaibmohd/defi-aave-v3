# DeFi Aave V3

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
  - [ ] APY and APR
  - [ ] Market forces
  - [ ] Utilization rate
  - [ ] Interest rate model - graph
  - [ ] Reserve
  - [ ] Atoken and debt token
    - rebase token
    - 1:1
  - [ ] Liquidity index -> animation?
- Contract architecture
  - Contract architecture
    - Flow (cache -> update state -> validation -> update interest -> execute -> check state)
  - Supply
    - [ ] Execution flow
    - [ ] linear interest
    - [ ] on behalf of
    - [x] Exercise
  - Borrow
    - [ ] Execution flow
    - [ ] compound interest
      - why supply -> linear and borrow -> compound -> protocol safety
    - [ ] reserve factor
    - [ ] ltv
    - [ ] liquidation threshold
    - [ ] asset price limit (liquidation price)
    - [ ] health factor
    - [ ] debt delegation
    - [x] Exercise
  - Repay
    - [ ] Execution flow
    - [x] Exercise
  - Withdraw
    - [ ] Execution flow
    - [ ] Conditions for withdraw (health factor)
    - [ ] Exercise
  - Liquidation
    - [ ] Execution flow
    - penalty
    - close factor
    - bonus
    - [ ] Exercise
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
- [GitHub aave-v3-core](https://github.com/aave/aave-v3-core)
- [Aave V3 book](https://calnix.gitbook.io/aave-book)

##### Transactions

- [Supply rETH tx](https://etherscan.io/tx/0xc1120138b3aa3dc6a49ef7e84ecd17530c273e2442f83e47025d819d9a700743)
- [Supply ETH tx](https://etherscan.io/tx/0x21de14e5c58b9431a70b780893d01f0b82f07a0495d851d97fc0e85c64887610)
- [Borrow DAI tx](https://etherscan.io/tx/0x5e4deab9462bec720f883522d306ec306959cb3ae1ec2eaf0d55477eed01b5a4)
- [Repay DAI tx](https://etherscan.io/tx/0x1145e9815060164ef9234bdbc6d88db97ac5dda7b1e30732dc981145604e0373)
- [Withdraw rETH](https://etherscan.io/tx/0x7442ab56bfe90a189516f44846b93d25aa0dde3bbfba935429ac561ab34bc575)
- [Withdraw ETH](https://etherscan.io/tx/0x748e56cfaa10b6d629bd06badfdf83b337956e640523bbb1805901e11915c517)

- [Borrow ETH - waiting for liquidation](https://etherscan.io/tx/0xfe4b17b089b50bf9c2b00561061b4205e72bf9695c63e7fde31d54f299b9392f)

##### Misc

- [DeFiLama Swap](https://swap.defillama.com/)
