// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Swimmer {
    // Mapping to store user address to hash
    mapping(address => string) private userHashes;
    event HashStored(address indexed user, string hash);

    function storeHash(string calldata hash) external {
        // Check if the hash has already been stored
        require(bytes(userHashes[msg.sender]).length == 0, "Hash already stored for this address");
        
        userHashes[msg.sender] = hash;
        emit HashStored(msg.sender, hash);
    }

    function getHash(address user) external view returns (string memory) {
        return userHashes[user];
    }
}
