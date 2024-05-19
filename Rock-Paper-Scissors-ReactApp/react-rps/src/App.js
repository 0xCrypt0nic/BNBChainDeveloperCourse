import "./App.css";
import React, { useState, useEffect } from "react";
import { ethers } from "ethers";
import ActionButton from "./components/ActionButton";
import Player from "./components/Player";
import Button from "react-bootstrap/Button";
import ContractAbi from "./ContractAbi.json";
import InputGroup from "react-bootstrap/InputGroup";
import Form from "react-bootstrap/Form";

const App = () => {
  const contractAddress = "";
  const [playerAction, setPlayerAction] = useState("");
  const [computerAction, setComputerAction] = useState("");
  const [betAmount, setBetAmount] = useState(0);

  const onActionSelected = (selectedAction) => {
    setPlayerAction(selectedAction);
    setComputerAction("");
  };

  const provider = new ethers.providers.Web3Provider(window.ethereum);

  const [connButtonText, setConnButtonText] = useState("Connect to Wallet");
  const [account, setAccount] = useState(null);
  const [contract, setContract] = useState(null);
  const [contractChoice, setContractChoice] = useState(null);
  const [txHash, setTxHash] = useState(0);

  useEffect(() => {
    connectWalletHandler();
  }, []);

  const connectWalletHandler = () => {
    if (window.ethereum) {
      provider.send("eth_requestAccounts", []).thend(async () => {
        await accountChangedHandler(provider.getSigner());
      });
    } else {
      alert("error connecting to Wallet");
    }
  };

  const accountChangedHandler = async (newAccount) => {
    const address = await newAccount.getAddress();
    const balance = await newAccount.getBalance();
    setConnButtonText(address);
    setAccount(address);
    await getUserBalance(address);
    connectContract();
  };

  const getUserBalance = async (address) => {
    const balance = await provider.getBalance(address, "latest");
  };

  const connectContract = () => {
    try {
      let tempProvider = new ethers.providers.Web3Provider(window.ethereum);
      let tempSigner = tempProvider.getSigner();
      let tempContract = new ethers.Contract(
        contractAddress,
        ContractAbi,
        tempSigner
      );
      setContract(tempContract);
    } catch (error) {
      alert(`An error accured when connecting to the smart contract ${error}`);
      console.error("Error: ", error);
    }
  };

  const play = async () => {
    setComputerAction("");
    const overrides = {
      gasLimit: 200000,
      value: ethers.utils.parseEther(`${betAmount}`),
    };
  };

  let choice = 3;
  if (playerAction == "rock") {
    choice = 1;
  } else if (playerAction == "paper") {
    choice = 2;
  }

  if (betAmount < 0.001 && playerAction == "") {
    alert("Bet Amount is too small or player action has'nt been chosen");
  }else{
    try{
      const transaction = await contract.play(choice, overrides);
      setTxHash(transaction.hash);
      console.log(`Transaction ${transaction.hash} complete !`);

      await transaction.wait();

      fetchContractChoice();
    }catch(error){
      alert(`Failed transaction, please try again`);
      console.error("Error: ", error);
    }
  }
};
