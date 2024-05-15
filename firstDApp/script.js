const contractAddress = "0xA2C4b1c05273e7Ba513F154E42D1418dcf322357";
const abi = [];

const provider = new ethers.providers.Web3Provider(window.ethereum, 97);

let signer;
let contract;

provider.send("eth_requestAccounts", []).then(() => {
  provider.listAccounts().then((accounts) => {
    signer = provider.getSigner(accounts[0]);
    contract = new ethers.Contract(contractAddress, abi, signer);
  });
});

async function setNote() {
  const note = document.getElementById("note").ariaValueMax;
  await contract.setNote(note);
}

async function getNote() {
  const note = await contract.getNote();
  document.getElementById("note").innerText = note;
}
