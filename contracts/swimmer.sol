// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import { IEntropyConsumer } from "@pythnetwork/entropy-sdk-solidity/IEntropyConsumer.sol";
import { IEntropy } from "@pythnetwork/entropy-sdk-solidity/IEntropy.sol";

contract Swimmer is IEntropyConsumer {
    mapping(address => string) private userHashes;
    event HashStored(address indexed user, string hash);
    IEntropy public entropy;
    mapping(uint64 => address) private requestOwners;
    event RandomNumberRequested(address indexed user, uint64 sequenceNumber);
    event RandomNumberReceived(address indexed user, uint64 sequenceNumber, bytes32 randomNumber);
    address public oracleAddress;
    address public selfKisserAddress;
    event Whitelisted(address indexed user);

    constructor(address entropyAddress, address _selfKisserAddress) {
        entropy = IEntropy(entropyAddress);
        selfKisserAddress = _selfKisserAddress;
    }

    function storeHash(string calldata hash) external {
        require(bytes(userHashes[msg.sender]).length == 0, "Hash already stored for this address");
        userHashes[msg.sender] = hash;
        emit HashStored(msg.sender, hash);
    }

    function getHash(address user) external view returns (string memory) {
        return userHashes[user];
    }

    function requestRandomNumber(bytes32 userRandomNumber) external payable {
        address entropyProvider = entropy.getDefaultProvider();
        uint256 fee = entropy.getFee(entropyProvider);
        uint64 sequenceNumber = entropy.requestWithCallback{ value: fee }(entropyProvider, userRandomNumber);
        requestOwners[sequenceNumber] = msg.sender;
        emit RandomNumberRequested(msg.sender, sequenceNumber);
    }

    function entropyCallback(
        uint64 sequenceNumber,
        address provider,
        bytes32 randomNumber
    ) internal override {
        address user = requestOwners[sequenceNumber];
        require(user != address(0), "Invalid sequence number");
        emit RandomNumberReceived(user, sequenceNumber, randomNumber);
    }

    function getEntropy() internal view override returns (address) {
        return address(entropy);
    }

    function setOracleAddress(address _oracleAddress) external {
        oracleAddress = _oracleAddress;
    }

    function whitelistSelf() external {
        (bool success, ) = selfKisserAddress.call(
            abi.encodeWithSignature("selfKiss(address)", oracleAddress)
        );
        require(success, "Whitelisting failed");
        emit Whitelisted(msg.sender);
    }

    function isWhitelisted(address user) external view returns (bool) {
        (bool success, bytes memory result) = oracleAddress.staticcall(
            abi.encodeWithSignature("tolled(address)", user)
        );
        require(success, "Whitelist check failed");
        return abi.decode(result, (bool));
    }

    function readOracleData() external view returns (uint256) {
        (bool success, bytes memory result) = oracleAddress.staticcall(
            abi.encodeWithSignature("read()")
        );
        require(success, "Oracle read failed");
        return abi.decode(result, (uint256));
    }
}
