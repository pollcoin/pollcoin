// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.7.5;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";

contract Pollcoin is ERC20 {
    using SafeMath for uint256;
    
    struct Info { uint256 share; uint256 price; }
    
    struct Link { uint256 stamp; mapping(address => Info) infos; }
    
    mapping (string => mapping(string => Link)) public links;
    
    constructor() ERC20("Pollcoin", "POCO") { _mint(msg.sender, 10**18); }
    
    function vote(string memory input, string memory output, address seller, uint256 share, uint256 price) public {
        Link storage link = links[input][output];
        if (link.stamp == 0) { link.infos[address(0)].share = 10 ** 9; link.stamp = block.timestamp; }
        transferFrom(address(0), msg.sender, link.infos[msg.sender].share.mul(link.infos[msg.sender].price));
        transferFrom(msg.sender, address(0), link.infos[msg.sender].share.mul(price));
        link.infos[msg.sender].price = price;
        transferFrom(address(0), seller, share.mul(link.infos[seller].price));
        transferFrom(msg.sender, seller, share.mul(link.infos[seller].price));
        link.infos[seller].share = link.infos[seller].share.sub(share);
        link.infos[msg.sender].share = link.infos[msg.sender].share.add(share);
        transferFrom(msg.sender, address(0), share.mul(price));
    }
}
