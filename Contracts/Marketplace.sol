// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";


contract marketplace is ReentrancyGuard{

        address payable public immutable feeaccount;
    uint public immutable feepercent;
    uint public itemcount;
    event ItemListed(uint tokenid,address indexed nft,uint price,address indexed seller);
    event ItemPurchased(uint tokenid,address seller,address buyer,uint price);

    struct Item{
        uint itemid;
        IERC721 nft;
        uint tokenid;
        uint price;
        address payable owner;
        bool sold;
    }
    mapping(uint=>Item) public  items;
    constructor() {
        feeaccount=payable(msg.sender);
        feepercent=2;
        
    }
    function listitem(IERC721 _nft, uint _tokenid,uint _price )external nonReentrant{
        require(_price>0,"Price should be greater than zero");
        // _nft.safeTransferFrom(msg.sender, address(this), _tokenid);
        _nft.transferFrom(msg.sender,address(this),_tokenid);
        itemcount++;
        items[itemcount]=Item(
            itemcount,
            _nft,
            _tokenid,

            _price ,
            payable(msg.sender),
            false);

    emit ItemListed(_tokenid, address(_nft), _price, msg.sender);
    }

    function purchaseitem(uint _tokenid)public payable {
        require(_tokenid <=itemcount,"Item not listed");
        require(!items[_tokenid].sold,"Item already sold");
       
        IERC721 nft = items[_tokenid].nft;
        uint itemprice=items[_tokenid].price ;
        uint totalprice=itemprice + (itemprice * feepercent/100);
       
        require(msg.value >= totalprice,"Not enough ether" );
        items[_tokenid].owner.transfer(items[_tokenid].price);
        feeaccount.transfer(totalprice-itemprice);
         nft.setApprovalForAll(msg.sender,true);
        nft.safeTransferFrom(address(this),msg.sender,_tokenid);
        items[_tokenid].owner=payable(msg.sender);
        items[_tokenid].sold=true;
    }

    function showitem(uint index)public view returns(Item memory){
            return items[index];
    }

}



