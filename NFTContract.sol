// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MyToken is ERC1155, Ownable {
    address public contractAdr;
    uint256[] supplies = [5000000,100,50,1];
    uint256[] minted =[0,0,0,0];
    uint256[] rate = [0.0001 ether,1 ether , 2 ether , 15 ether];
  
    constructor() ERC1155("https://api.mysite.com/tokens/{id}") {    }
    
    function setURI(string memory newuri) public onlyOwner{
        _setURI(newuri);
    }
    
    function mint(address to ,uint256 id, uint256 amount)
        public
        payable
    {
        require(id<= supplies.length , "Token ID invalid");
        require(id !=0 , "Token can't be minted");
        uint256 index = id -1;
        require (minted[index]+amount <= supplies[index], "Total supply exceed");
        require(msg.value >= rate[index] * amount, "pay more");
        minted[index] += amount;
        _mint(to, id, amount,"");
    }

    function withdraw() public payable onlyOwner{
        payable(msg.sender).transfer(address(this).balance);
    }
    
    function setContractAdr() public{
        require(contractAdr == address(0x0));
        contractAdr = msg.sender;
    }
    
    function isApprovedForAll(address account, address operator) public view override returns (bool) {
        return super.isApprovedForAll(account,operator) || msg.sender == contractAdr;
    }
}
