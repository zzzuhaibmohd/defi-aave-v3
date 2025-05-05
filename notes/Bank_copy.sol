pragma solidity 0.8.26;

// Code 1
contract Bank {
    // user => debt
    mapping(address => uint256) public debts;
    // R(n-1)
    uint256 public cumulativeRates = 1e18;
    // R(k-1)
    // user => cumulative rate when user borrowed
    mapping(address => uint256) public userCumulativeRates;

    function updateCumulativeRates() public {}

    function calculateDebt(address user) external view returns (uint256) {
        return debts[user]
            * cumulativeRates 
            / userCumulativeRates[user];
    }

    function borrow(uint256 amount) external {
        updateCumulativeRates();
        debts[msg.sender] += amount * 1e18 / cumulativeRates;
        userCumulativeRates[msg.sender] = cumulativeRates;
    }

    function repay(uint256 amount) external {
        updateCumulativeRates();
        debts[msg.sender] -= amount * 1e18 / cumulativeRates;
        userCumulativeRates[msg.sender] = cumulativeRates;
    }
}
