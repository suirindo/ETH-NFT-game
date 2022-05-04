const { header } = require("express/lib/request")

const main = async () => {
    const gameContractFactory = await hre.ethers.getContractFactory("MyEpicGame"); // MyEpicGameがコンパイルされる⇨コントラクトを扱うために必要なファイルがartifactsディレクトリ直下に生成される。
    const gameContract = await gameContractFactory.deploy();
    const nftGame = await gameContract.deployed();

    console.log("Contract deployed to:", nftGame.address);
};

const runMain = async () => {
    try {
        await main();
        process.exit(0);
    } catch (error) {
        console.log(error);
        process.exit(1);
    }
};
runMain();