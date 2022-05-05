// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
// NFT発行のコントラクト ERC721.sol をインポートします。
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

//OpenZeppelinが提供するヘルパー機能をインポートします。
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

//Base64.solからヘルパー関数をインポートする
import "./libraries/Base64.sol";

import "hardhat/console.sol";

//MyEpicGameコントラクトは、NFTの標準規格であるERC721を継承する
contract MyEpicGame is ERC721{
    // キャラクターのデータを格納するCharacterAttributes 型の構造体('struct')を作成する
    struct CharacterAttributes {
        uint characterIndex;
        string name;
        string imageURI;
        uint hp;
        uint maxHp;
        uint attackDamage;
    }

    struct BigBoss {
        string name;
        string imageURI;
        uint hp;
        uint maxHp;
        uint attackDamage;
    }
    BigBoss public bigBoss;

    //Openzeppelinが提供するtokenIdsを簡単に追跡するライブラリを呼び出している
    using Counters for Counters.Counter;
    // tokenIdはNFTの一意な識別子で、0, 1, 2, ,,,Nのように付与される
    Counters.Counter private _tokenIds;

    // キャラクターのデフォルトデータを保持するための配列defaultCharactersを作成する。それぞれの配列はCharacterAttributes型である。
    CharacterAttributes[] defaultCharacters;

    // NFTのtokenIdとCharacterAttributesを紐づけるmappingを作成する。nftHlderAttributesはプレイヤーのNFTの状態を保存する変数
    // solidityにおけるmappingは、他の言語におけるハッシュテーブルや辞書のような役割を果たす。
    // mapping (_Key => _Value) public mappingName keyとvalueのペア形式でデータを格納する
    mapping(uint256 => CharacterAttributes) public nftHolderAttributes;

    // ユーザーのアドレスとNFTのtokenIdを紐づけるmappingを作成する
    mapping(address => uint256) public nftHolders;

    constructor(
        // プレイヤーが新しくNFTキャラクターをMintする際に、キャラクターを初期化するために渡されるデータを設定。これらの値はフロントエンド（jsファイル）から渡される。
        string[] memory characterNames,
        string[] memory characterImageURIs,
        uint[] memory characterHp,
        uint[] memory characterAttackDmg,
        // 下記の変数は、run.jsやdeploy.jsを介して渡される
        string memory bossName,
        string memory bossImageURI,
        uint bossHp,
        uint bossAttackDamage
    )
        ERC721("Stand Alone Complex", "SAC")
    {
        //ボスを初期化。ボスの情報をグローバル状態変数"bigBoss"に保存する
        bigBoss = BigBoss({
            name: bossName,
            imageURI: bossImageURI,
            hp: bossHp,
            maxHp: bossHp,
            attackDamage: bossAttackDamage
        });
        console.log("Done initializing boss %s w/ HP %s, img %s", bisBoss.name, bisBoss.hp, bisBoss.imageURI);

    }

    {
        // ゲームで扱うすべてのキャラクターをループ処理で呼び出し、それぞれのキャラクターに付与されるデフォルト値をコントラクトに保存する
        for(uint i = 0; i < characterNames.length; i += 1) {
            defaultCharacters.push(CharacterAttributes({
                characterIndex: i,
                name: characterNames[i],
                imageURI: characterImageURIs[i],
                hp: characterHp[i],
                maxHp: characterHp[i],
                attackDamage: characterAttackDmg[i]
            }));
            CharacterAttributes memory character = defaultCharacters[i];
            // hardhatのconsole.log()では、任意の順番で最大4つのパラメータを指定できる
            // 使用できるパラメータの種類: uint, string, bool, address
            console.log("Done initializing %s w/ HP %s, img %s", character.name, character.hp, character.imageURI);
        }
        // 次のNFTがMintされるときのカウンターをインクリメントする
        _tokenIds.increment();
    }

    // ユーザーはmintCharacterNFT関数を呼び出してNFTをMintすることができる
    // _characterIndexはフロントエンドから送信される
    function mintCharacterNFT(uint _characterIndex) external {
        // 現在のtokenIdを取得する(constructor内でインクリメントしているため、1から始まる)
        uint256 newItemId = _tokenIds.current();

        // msg.sender でフロントエンドからユーザーのアドレスを取得して、NFTをユーザーにMintする
        _safeMint(msg.sender, newItemId);

        // mappingで定義したtokenIdをCharacterAttributesに紐づける
        nftHolderAttributes[newItemId] = CharacterAttributes({
            characterIndex: _characterIndex,
            name: defaultCharacters[_characterIndex].name,
            imageURI: defaultCharacters[_characterIndex].imageURI,
            hp: defaultCharacters[_characterIndex].hp,
            maxHp: defaultCharacters[_characterIndex].maxHp,
            attackDamage: defaultCharacters[_characterIndex].attackDamage
        });

        console.log("Minted NFT w/ tokenId %s and characterIndex %s", newItemId, _characterIndex);

        // NFTの所有者を簡単に確認できるようにする
        nftHolders[msg.sender] = newItemId;

        // 次に使用する人のためにtokenIdをインクリメントする
        _tokenIds.increment();
    }

    function attackBoss() public{
        // 1.プレイヤーのNFTの状態を取得する
        uint256 nftTokenIdOfPlayer = nftHolders[msg.sender];
        CharacterAttributes storage player = nftHolderAttributes[nftTokenIdOfPlayer];
        console.log("\nPlayer w/ character %s about to attack. Has %s HP and %s AD", player.name, player.hp, player.attackDamage);
        console.log("Boss %s has %s HP and %s AD", bigBoss.name, bigBoss.hp, bigBoss.attackDamage);

        // 2.プレイヤーのHPが0以上であることを確認する
        require (
            player.hp > 0,
            "Error: character must have H to attack boss."
        );
        // 3.ボスのHPが0以上であることを確認する
        require (
            biBoss.hp > 0,
            "Error: boss must have HP to attack boss."
        )
    }

    // nftHolderAttributes を更新して、tokenURIを添付する関数を作成
    function tokenURI(uint256 _tokenId) public view override returns(string memory) {
        CharacterAttributes memory charAttributes = nftHolderAttributes[_tokenId];
        // charAttributes のデータを編集して、JSONの構造に合わせた変数に格納している
        string memory strHp = Strings.toString(charAttributes.hp);
        string memory strMaxHp = Strings.toString(charAttributes.maxHp);
        string memory strAttackDamage = Strings.toString(charAttributes.attackDamage);

            string memory json = Base64.encode(
                // abi.encodePacked で文字列を結合する
                // OpenSeaが採用するJSONデータをフォーマットしている
                abi.encodePacked(
                    '{"name": "',
                    charAttributes.name,
                    ' -- NFT #: ',
                    Strings.toString(_tokenId),
                    '", "description": "This is an NFT that lets people play in the game Metaverse Slayer!", "image": "',
                    charAttributes.imageURI,
                    '", "attributes": [ { "trait_type": "Health Points", "value": ',strHp,', "max_value":', strMaxHp,'}, {"trait_type": "Attack Damage", "value": ',
                    strAttackDamage, '}]}'
                )
            );
            // 文字列 data:application/json;base64, と json の中身を結合して、tokenURIを作成している
            string memory output = string(
                abi.encodePacked("data:application/json;base64,", json)
            );
            return output;
    }

}

