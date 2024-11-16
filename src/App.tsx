import React, { useState, useEffect } from "react";
import "./styles/App.custom.css";
import { ConnectButton } from "@rainbow-me/rainbowkit";
import { useAccount, useWriteContract, useReadContract } from "wagmi";
import { abi } from "./contractABI";

const CONTRACT_ADDRESS = "0x936c839F678AAfda8d8e8a0FBEA4b363eF7D9926";

function App() {
  const [storedHash, setStoredHash] = useState<string | null>(null);
  const { isConnected, address } = useAccount();

  // Contract write hook
  const { writeContract, isPending } = useWriteContract();

  // Contract read hook
  const { data: savedHash, refetch } = useReadContract({
    abi,
    address: CONTRACT_ADDRESS,
    functionName: "getHash",
    args: address ? [address] : undefined,
  });

  useEffect(() => {
    const checkStoredHash = async () => {
      if (isConnected && address) {
        try {
          await refetch();
          if (savedHash) {
            setStoredHash(savedHash as string);
          } else {
            console.log("nothing to show");
            setStoredHash(null);
          }
        } catch (error) {
          console.error("Failed to get hash:", error);
        }
      }
    };

    checkStoredHash();
  }, [isConnected, address, refetch, savedHash]);

  const handleStoreHash = async () => {
    try {
      writeContract({
        abi,
        address: CONTRACT_ADDRESS,
        functionName: "storeHash",
        args: ["0x1234567890"],
      });
    } catch (error) {
      console.error("Failed to store hash:", error);
    }
  };

  return (
    <div className="container">
      <div className="card">
        <div>
          <h1 className="title">Bangkok Swimmer</h1>
          <p className="subtitle">
            {!isConnected
              ? "Connect your wallet to register!"
              : storedHash
              ? "Your wallet is already registered!"
              : "Your wallet is connected! Let's get started!"}
          </p>
        </div>

        <div className="button-container">
          <ConnectButton />
          {isConnected && !storedHash && (
            <button className="fetch-button" onClick={handleStoreHash}>
              {isPending ? "Storing..." : "Store Hash On-Chain"}
            </button>
          )}

          {isConnected && storedHash && (
            <div className="hash-display visible">
              <strong>
                Your wallet was already registered in this block hash:
              </strong>
              <br />
              {storedHash}
            </div>
          )}
        </div>
      </div>
    </div>
  );
}

export default App;
