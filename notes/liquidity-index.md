# Liquidity and borrow indexes

[`ReserveLogic.updateState`](https://github.com/aave-dao/aave-v3-origin/blob/5431379f8beb4d7128c84a81ced3917d856efa84/src/contracts/protocol/libraries/logic/ReserveLogic.sol#L92-L108)

```shell
ReserveLogic.updateState
├─ _updateIndexes
│  ├─ MathUtils.calculateLinearInterest
│  └─ MathUtils.calculateCompoundedInterest
└─ _accrueToTreasury
```

[`ReserveLogic.updateInterestRatesAndVirtualBalance`](https://github.com/aave-dao/aave-v3-origin/blob/5431379f8beb4d7128c84a81ced3917d856efa84/src/contracts/protocol/libraries/logic/ReserveLogic.sol#L162-L199)

[`DefaultReserveInterestRateStrategyV2.calculateInterestRates`](https://github.com/aave-dao/aave-v3-origin/blob/5431379f8beb4d7128c84a81ced3917d856efa84/src/contracts/misc/DefaultReserveInterestRateStrategyV2.sol#L125-L177)

```shell
ReserveLogic.updateInterestRatesAndVirtualBalance
└─ IReserveInterestRateStrategy.calculateInterestRates
```
