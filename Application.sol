// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
import "./Interface.sol";


contract marketPlace{

    uint256 constant COIN = 1;
    uint256 constant SKIN1 = 2;
    uint256 constant SKIN2 = 3;
    uint256 constant KINGSKIN = 4;

    ERC1155 contractAdr;
    address owner;
    constructor(address adr){
        contractAdr = ERC1155(adr);
        owner = msg.sender;
        contractAdr.setContractAdr();
    }

    function buyCoin(uint amount) public payable{
        contractAdr.mint{value:msg.value}(msg.sender,1,amount);
    }

    function buySkin (uint tokenID) public payable{
        require(contractAdr.balanceOf(msg.sender,tokenID)==0 , "Can't buy more NFT");
        contractAdr.mint{value:msg.value}(msg.sender,tokenID,1);
    }

    function transferSkin(address to, uint tokenID) public{
        require(contractAdr.balanceOf(to,tokenID)==0 , "Can't send more NFT");
        contractAdr.safeTransferFrom(msg.sender,to,tokenID,1,"");
    }
    function transferCoin(address to, uint amount) public {
        contractAdr.safeTransferFrom(msg.sender,to,1,amount,"");
    }

    function transferBatch(address to, uint256[] calldata tokenID , uint256 [] calldata amount) public{
        for(uint i=0;i<tokenID.length;++i){
            if(tokenID[i]!=1){
                require(contractAdr.balanceOf(to,tokenID[i])==0 , "Can't send more NFT");
            }
        }
        contractAdr.safeBatchTransferFrom(msg.sender,to,tokenID,amount,"0x00");
    }
    
    function withdraw() public payable{
        require(msg.sender == owner);
        payable(msg.sender).transfer(address(this).balance);
    }
}
