const fs = require("fs");

const CID = "QmXa3PvMSkMgHzayisLdseBLSvQjc2H93LPphu9MCsiLa3";

for (let i = 0; i < 10; i++) {
  const filename = `${i}.json`;
  const data = {
    name: "NFT tutorial",
    description: "Icons NFT",
    image: `ipfs://${CID}/${i}.png`,
  };

  const jsonData = JSON.stringify(data);
  fs.writeFile(`./metadata/${filename}`, jsonData, (err) => {
    if (err) throw err;
    console.log(`${filename} has been saved!`);
  });
}
