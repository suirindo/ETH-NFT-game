const main = async () => {
    // これにより、`MyEpicGame` コントラクトがコンパイルされます。
    // コントラクトがコンパイルされたら、コントラクトを扱うために必要なファイルが artifacts ディレクトリの直下に生成されます。
    const gameContractFactory = await hre.ethers.getContractFactory("MyEpicGame");
    // Hardhat がローカルの Ethereum ネットワークを、コントラクトのためだけに作成します。
    const gameContract = await gameContractFactory.deploy(
        ["MOTOKO", "BATO", "SAITO"], // キャラクターの名前
      [
        "https://i.imgur.com/zpuhM1K.png", // キャラクターの画像
        "https://i.imgur.com/QedG2Zk.png",
        "https://i.imgur.com/5pheBPs.png",
    ],
      [100, 200, 300], // キャラクターのHP
      [100, 50, 25], // キャラクターの攻撃力
      "waraiOtoko",//bossの名前
      "https://i.imgur.com/CGbvLID.png", //image
      10000, //hp
      50 //attack
    );
    // ここでは、`nftGame` コントラクトが、
    // ローカルのブロックチェーンにデプロイされるまで待つ処理を行っています。
    const nftGame = await gameContract.deployed();
  
    console.log("Contract deployed to:", nftGame.address);
  
    // /* ---- mintCharacterNFT関数を呼び出す ---- */
    // // Mint 用に再代入可能な変数 txn を宣言
    // let txn;
    // // 3体のNFTキャラクターの中から、0番目のキャラクターを Mint しています。
    // // キャラクターは、3体（0番, 1番, 2番）体のみ。
    // txn = await gameContract.mintCharacterNFT(2);
    // // Minting が仮想マイナーにより、承認されるのを待ちます。
    // await txn.wait();
    // txn = await gameContract.attackBoss();
    // await txn.wait();
    // console.log("First attack.");
    // txn = await gameContract.attackBoss();
    // await txn.wait();
    // console.log("Second attack.");

    // console.log("Done!");
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