const { header } = require("express/lib/request")

const main = async () => {
    const gameContractFactory = await hre.ethers.getContractFactory("MyEpicGame"); // MyEpicGameがコンパイルされる⇨コントラクトを扱うために必要なファイルがartifactsディレクトリ直下に生成される。
    const gameContract = await gameContractFactory.deploy( // この中に格納されている情報が、MyEpicGame.solのconstructorに渡される
        ["MOTOKO", "BATO", "SAITO"], // キャラクターの名前
        [
            "https://i.imgur.com/zpuhM1K.png", // キャラクターの画像
            "https://i.imgur.com/QedG2Zk.png",
            "https://i.imgur.com/5pheBPs.png",
        ],
        [300, 200, 100], //キャラクターのHP
        [70, 90, 50], //キャラクターの攻撃力
        "waraiOtoko",//bossの名前
        "https://i.imgur.com/CGbvLID.png", //image
        10000, //hp
        50 //attack
    );
    await gameContract.deployed();
    console.log("Contract deployed to:", gameContract.address);

    // 再代入可能な変数 txn を宣言
    let txn;
    // 3体のNFTキャラクターの中から、３番目のキャラクターをMint
    txn = await gameContract.mintCharacterNFT(2);

    // Mintingが仮想マイナーにより承認されるのを待つ
    await txn.wait();

    // NFTのURIの値を取得する。tokenURIはERC721から継承した関数
    let returnedTokenUri = await gameContract.tokenURI(1);
    console.log("Token URI:", returnedTokenUri);
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