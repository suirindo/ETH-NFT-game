// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
import "hardhat/console.sol";

contract MyEpicGame {
    // キャラクターのデータを格納するCharacterAttributes 型の構造体('struct')を作成する
    struct CharacterAttributes {
        uint characterIndex;
        string name;
        string imageURI;
        uint hp;
        uint maxHp;
        uint attackDamage;
    }
    // キャラクターのデフォルトデータを保持するための配列defaultCharactersを作成する。それぞれの配列はCharacterAttributes型である。
    CharacterAttributes[] defaultCharacters;
    constructor(
        // プレイヤーが新しくNFTキャラクターをMintする際に、キャラクターを初期化するために渡されるデータを設定。これらの値はフロントエンド（jsファイル）から渡される。
        string[] memory characterNames,
        string[] memory characterImageURIs,
        uint[] memory characterHp,
        uint[] memory characterAttackDmg
    ) 
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
            console.log("Done initializing $s w/ HP %s, img %s", character.name, character.hp, character.imageURI);
        }
    }
}

