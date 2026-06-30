# 🎮 Game Manager - LAYER VILLAGE ROYALE

> **⚙️ Layer Village Royale ⚙️**  
> 15人のプレイヤーが隠された真実を暴かれるまでの15分間の緊張とドラマが詰まったマルチプレイアクションゲーム

![Godot](https://img.shields.io/badge/Godot-4.7-blue?logo=godot-engine)
![GDScript](https://img.shields.io/badge/GDScript-98.5%25-brightgreen)
![License](https://img.shields.io/badge/License-MIT-green)
![Status](https://img.shields.io/badge/Status-Active%20Development-yellow)

---

## 🎯 プロジェクト概要

**LAYER VILLAGE ROYALE** は、Godot Engine で構築されたオンラインマルチプレイアクションゲームです。

### ✨ コアコンセプト

```
┌─────────────────────────────────────────────────────────────┐
│  15人のプレイヤーが、一つの空間（コロシアム）に集められる │
│                                                              │
│  🎭 Layer 2: 表の顔 (ApparentFace)                          │
│     ↓ 誰もが見える公開パラメータ                            │
│                                                              │
│  👥 Layer 1: サブ職業 (SubOccupation)                       │
│     ↓ シーズン制で全員に公開                                │
│                                                              │
│  👑 Layer 3: メイン職業 (MainOccupation)  ← 秘密！         │
│     ↓ 10分まで完全非公開...                                 │
│                                                              │
│  ⏰ 10分00秒: 【TRUTH REVEALED】                            │
│     全員の本当の職業が暴露される                            │
│     ➔ コロシアムの運命は分かれ道へ...                      │
└─────────────────────────────────────────────────────────────┘
```

### 🎭 5つのルート分岐

| ルートID | ルート名 | 条件 | 描写 |
|---------|---------|------|------|
| ① | **NORMAL** | 生存 2～14人 | 通常の戦闘継続 |
| ② | **TYRANT** | 生存 1人 | 独裁者の君臨 |
| ③ | **DESPAIR** | 全員死亡 (10分時点) | 絶望のエンディング |
| ④ | **MIRACLE_DESPAIR** | 生存 15人 (野良) | 奇跡の野良全員生存 |
| ⑤ | **GUILD_RAID** | 生存 15人 (ギルド) | ギルド統率レイド |

---

## 🕐 ゲーム進行タイムライン

### Phase 1: 隠蔽の時間 (0:00 ～ 9:54)
- プレイヤー同士が戦闘
- 真の職業は秘密のまま
- 戦略的な同盟・裏切り

### Phase 2: 情報攪乱 & オイルハザード
- **2:30** ⚡ 第1波・情報攪乱パケット配分
  - 全体:「セクターXX にオイル流入」アナウンス
  - 個別:3人に秘密の情報(真実or嘘)
  
- **3:00** 🛢️ オイル流入フェーズ1 (OIL_SLICK)
  - 指定セクターが汚染開始
  
- **5:30** ⚡ 第2波・情報攪乱パケット配分
- **6:00** 🔥 オイル発火フェーズ2 (IGNITION)
  - ダメージ増加
  
- **8:30** ⚡ 第3波・情報攪乱パケット配分
- **9:00** 💥 オイル連鎖爆発フェーズ3 (CHAIN_EXPLOSION)
  - 激ダメージ継続

### Phase 3: 世界整合アナウンス (9:55)
- **BGM・SE完全停止** ← 衝撃演出
- 重い沈黙が戦場を支配

### Phase 4: 真実の顕現 (10:00)
- **【TRUTH REVEALED】** が全員に表示
- 全プレイヤーの本当の職業が暴露
- 戦局が大激変

### Phase 5: 最終決戦 (10:01 ～ 15:00)
- 本当の職業に基づく新しい戦略
- ルート分岐のイベント発動

---

## 🎮 ゲームシステム

### 職業システム (3層階層)

#### Layer 3: メイン職業 🥷 (秘密)
```gdscript
WARRIOR    # 戦士 (攻撃 +100)
KNIGHT     # 騎士 (防御 +100)
BARRIERIST # 結界士 (魔防 +100)
MAGE       # 魔導士 (MP +100)
ARCHER     # 弓士 (俊敏 +100)
```

#### Layer 2: 表の顔 🎭 (公開・偽装可能)
```
GUARDIAN, PHANTOM, BERSERKER, VAGABOND, 
SAGE, HUNTER, IRON_WALL, WANDERER
```

#### Layer 1: サブ職業 👥 (シーズン制・全員公開)
```
NINJA, DRAGOON, MACHINIST, BARD
```

### 武器システム ⚔️

三すくみバランス:
- **SWORD (大剣)** → SHIELD に勝利
- **SHIELD (大盾)** → BARRIER_STAFF に勝利
- **BARRIER_STAFF** → SWORD に勝利

### マップシステム 🗺️

#### 16セクター属性
```gdscript
WARRIOR_VILLAGE    # 戦士村
KNIGHT_VILLAGE     # 騎士村
BARRIER_VILLAGE    # 結界村
MAGE_VILLAGE       # 魔導村
ARCHER_VILLAGE     # 弓士村
SHRINE             # 神殿
WASTELAND          # 荒野
FOREST             # 森
MOUNTAIN           # 山
ISLAND             # 孤島
```

### 🛢️ オイルハザードシステム

段階的なダメージと心理戦:

```gdscript
NORMAL          # オイルなし
OIL_SLICK       # 初期汚染 (2ダメ/秒)
IGNITION        # 発火状態 (5ダメ/秒)
CHAIN_EXPLOSION # 連鎖爆発 (10ダメ/秒)
```

#### 情報攪乱メカニズム 🎰
- **全体公開**: セクター XX にオイル流入のアナウンス
- **個別秘密**: 3人プレイヤーに真実 or 嘘 のサイドメッセージ
  - 真実なら: 実際のセクターIDを通知
  - 嘘なら: 無関係な偽ID（+5）をでっち上げて脳をバグらせる

**戦略的影響:**
- プレイヤー同士の信頼が揺らぐ
- 嘘つきか正直者かの判定が難しくなる
- 真実の10分に向けた心理戦

---

## 📁 プロジェクト構成

```
Game-Manager/
├── assets/               ★ 生の素材データ
│   ├── environments/     # 背景・環境アセット
│   ├── characters/       # キャラクターモデル・テクスチャ
│   ├── stages/           # ステージアセット (コロシアム)
│   └── ui/               # UI素材
│
├── scenes/               ★ シーンファイル + 対応スクリプト
│   ├── core/             # ゲームコア (GameManager, Main)
│   ├── entities/         # プレイヤー・敵・NPC
│   ├── levels/           # ステージ・レベル
│   ├── objects/          # 矢などのゲームオブジェクト
│   └── ui/               # UI画面 (メニュー、HUD など)
│
└── scripts/              ★ シーン非依存のロジック・データ
    ├── autoload/         # グローバルマネージャー群
    ├── components/       # AI、戦闘、職業、マップ
    ├── data/             # ボス、武器、アイテムDB
    ├── managers/         # 経済、シーズン、タイル管理
    └── utils/            # デバッグツール
```

---

## 🚀 セットアップ

### 必須環境
- **Godot Engine 4.7+**
- **Jolt Physics** (推奨)
- **Git LFS** (大容量アセット用)

### インストール手順

```bash
# 1. リポジトリをクローン
git clone https://github.com/pandorapanchan34-oss/game-manager.git
cd game-manager

# 2. Git LFS を初期化 (推奨)
git lfs install
git lfs pull

# 3. Godot Editor でプロジェクトを開く
# File → Open Project → game-manager/project.godot を選択

# 4. ゲームを実行
# F5 または Play ボタンを押す
```

---

## 🛠️ 開発ガイド

### ファイル命名規則

| 種類 | 拡張子 | 例 |
|------|-------|-----|
| シーンファイル | `.tscn` | `game_manager.tscn` |
| GDScript | `.gd` | `player.gd` |
| リソース | `.tres` | `weapon_database.tres` |
| アセット | `.glb/.png/.jpg` | `urujen.glb` |

### スクリプト命名規則

```
scripts/
├── autoload/           # パスカルケース (グローバル変数)
│   └── NetworkManager.gd  ← 大文字スタート
├── components/
│   └── combat/weapon_system.gd  ← スネークケース
└── utils/
    └── debug_time_warper.gd
```

### コミットメッセージ

```
feat: 新しい職業追加 - ダークナイト実装
fix: ダメージ計算の不具合修正
refactor: マップ生成ロジック整理
docs: README更新
```

---

## 🎨 キャラクター

### Urujen
- 🎭 **表の顔**: 謎めいた戦士
- 🔮 特殊能力: 次元跳躍
- 📊 使用素材: GLB モデル + PNG テクスチャ

### Usagesu
- 🎭 **表の顔**: 放浪する旅人
- ⚡ 特殊能力: 速度強化
- 📊 使用素材: GLB モデル + 高解像度 PNG

---

## 🎯 今後の実装予定

- [ ] ネットワークマルチプレイ実装 (全プレイヤー同期)
- [ ] サーバー・クライアント アーキテクチャ完成
- [ ] エフェクト・パーティクル拡充
- [ ] サウンド・BGM 実装 (9分55秒の沈黙演出含む)
- [ ] キャラクター追加 (5体以上)
- [ ] UI 完全実装
- [ ] オイルハザードのビジュアルエフェクト
- [ ] バグ修正・最適化

---

## 📊 スクリプト統計

| カテゴリ | ファイル数 | 主要機能 |
|---------|-----------|--------|
| **Autoload** | 8 | ネットワーク、UI、職業、共鳴 |
| **Components** | 9 | AI、戦闘、職業、マップ、オイルハザード |
| **Data** | 6 | ボス、武器、アイテム、評判 |
| **Managers** | 5 | 経済、シーズン、タイル、メッセージ |
| **Core** | 4 | ゲーム管理、エンティティ |
| **UI** | 4 | HUD、メニュー、チャット |

---

## 🤝 貢献

バグ報告や機能提案は [Issues](https://github.com/pandorapanchan34-oss/game-manager/issues) でお願いします。

Pull Request も大歓迎です! 🎉

### 貢献の流れ

1. Fork してブランチを作成 (`git checkout -b feature/amazing-feature`)
2. 変更をコミット (`git commit -m 'feat: amazing feature'`)
3. ブランチにプッシュ (`git push origin feature/amazing-feature`)
4. Pull Request を作成

---

## 📜 ライセンス

このプロジェクトは **MIT License** の下で公開されています。
詳細は [LICENSE](./LICENSE) ファイルを参照してください。

---

## 👨‍💻 作者

- **@pandorapanchan34-oss**
- GitHub: [@pandorapanchan34-oss](https://github.com/pandorapanchan34-oss)

---

## 🔗 関連リンク

- 📖 [Godot 公式ドキュメント](https://docs.godotengine.org/)
- 🎮 [Godot コミュニティ](https://godotengine.org/community/)
- ⚡ [Jolt Physics](https://jolt-physics.github.io/)

---

**Made with ❤️ using Godot Engine**  
_Last Updated: 2026-06-30_
