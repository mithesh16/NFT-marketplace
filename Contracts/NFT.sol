// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract NFT is ERC721URIStorage{

        uint tokencount;
        constructor() ERC721("Heroes", "HERO") {

        }
        function mint(string memory _tokenuri) external returns (uint){
                    tokencount++;
                    _safeMint(msg.sender, tokencount);
                    _setTokenURI(tokencount, _tokenuri);
                    return tokencount;
                   

        }
}
