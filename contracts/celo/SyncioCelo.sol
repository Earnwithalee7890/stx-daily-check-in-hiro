// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract SyncioCelo is ERC721URIStorage, Ownable {
    uint256 private _nextTokenId;

    // Track user check-ins
    mapping(address => uint256) public userCheckIns;
    mapping(address => uint256) public lastCheckInTime;

    event ActivityLogged(address indexed user, uint256 totalCheckIns, uint256 timestamp);
    event BadgeMinted(address indexed user, uint256 tokenId);

    constructor() ERC721("Syncio Celo Badge", "SYNC") Ownable(msg.sender) {}

    // 1. Daily Check-in Function (Free on Celo)
    function logActivity() external {
        // Prevent spam: 1 check-in per day (86400 seconds)
        // For testing/hackathon purposes, we can lower this, but 1 day is standard.
        // require(block.timestamp >= lastCheckInTime[msg.sender] + 1 days, "Already checked in today");
        
        userCheckIns[msg.sender] += 1;
        lastCheckInTime[msg.sender] = block.timestamp;

        emit ActivityLogged(msg.sender, userCheckIns[msg.sender], block.timestamp);
    }

    // 2. Claim NFT Badge
    function mintBadge() external {
        require(userCheckIns[msg.sender] > 0, "Must log activity first");
        
        uint256 tokenId = _nextTokenId++;
        _mint(msg.sender, tokenId);
        
        // Example IPFS metadata for the Syncio badge
        _setTokenURI(tokenId, "ipfs://QmYourSyncioBadgeMetadataURI");

        emit BadgeMinted(msg.sender, tokenId);
    }

    function getCheckIns(address user) external view returns (uint256) {
        return userCheckIns[user];
    }
}
