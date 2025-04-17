# Liquidity and borrow indexes

[`ReserveLogic.updateState`](https://github.com/aave-dao/aave-v3-origin/blob/5431379f8beb4d7128c84a81ced3917d856efa84/src/contracts/protocol/libraries/logic/ReserveLogic.sol#L92-L108)

```shell
ReserveLogic.updateState
├─ _updateIndexes
│  ├─ MathUtils.calculateLinearInterest
│  └─ MathUtils.calculateCompoundedInterest
└─ _accrueToTreasury
```
