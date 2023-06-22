//"SPDX-License-Identifier:MIT
pragma solidity ^0.8.17;
import "managersRepo.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract Forif_contract is ERC721URIStorage,ManagersRepo {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    constructor() ERC721("ForifCertification", "FORIF") ManagersRepo() {
    }

    function mintCertification(address _user, string memory tokenURI)
        public
        returns (uint256)
    {
        require(isManager(msg.sender));
        uint256 newCertification = _tokenIds.current();
        _mint(_user, newCertification);
        _setTokenURI(newCertification, tokenURI);

        _tokenIds.increment();
        return newCertification;
    }

    function getTokenOf(address NFTowner) public view returns(string[] memory) {
        uint256 balance = balanceOf(NFTowner);
        string[] memory ownedTokens = new string[](balance);
        uint256 counter = 0;
        for(uint256 i = 0; i < _tokenIds.current(); ++i){
            if(ownerOf(i)==NFTowner){
                ownedTokens[counter] = tokenURI(i);
            }
            ++counter;
            if(counter==balance){
                break;
            }
        }
        return ownedTokens;
    }
}