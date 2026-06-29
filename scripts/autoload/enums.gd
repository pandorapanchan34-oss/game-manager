extends Node
class_name Enumas

# 📜 scripts/data/enums.gd
# 🌌 [LAYER VILLAGE ROYALE] 全次元共通定数定義パケット v1.0

# 👥 Layer3：メイン職業（完全非公開・TRUTH REVEALEDで暴露）
enum MainOccupation {
	WARRIOR,    # 戦士 (攻撃 +100)
	KNIGHT,     # 騎士 (防御 +100)
	BARRIERIST, # 結界士 (魔防 +100)
	MAGE,       # 魔導士 (MP +100)
	ARCHER      # 弓士 (俊敏 +100)
}

# 🎭 Layer2：表の顔（自己申告・偽装可能公開パラメータ）
enum ApparentFace {
	GUARDIAN,  # 守護者
	PHANTOM,   # 亡霊
	BERSERKER, # 狂戦士
	VAGABOND,  # 放浪者
	SAGE,      # 賢者
	HUNTER,    # 狩人
	IRON_WALL, # 鉄壁
	WANDERER   # 旅人
}

# 🥷 Layer1：サブ職業（シーズン制・全員に最初から公開）
enum SubOccupation {
	NINJA,         # 忍者
	DRAGOON,       # 竜騎士
	MACHINIST,     # 機工士
	BARD           # 吟遊詩人
}

# ⚔️ 武器タイプ（三すくみ・射撃チャージの判定用）
enum WeaponType {
	NONE,
	SWORD,  # 大剣
	SHIELD, # 大盾
	BARRIER_STAFF, # 結界杖
	MAGE_STAFF,    # 魔導杖
	BOW     # 長弓
}

# 🗺️ 16セクター属性ID（マップ生成用・大自然拡張版）
enum SectorType {
	WARRIOR_VILLAGE, # 戦士村 (0)
	KNIGHT_VILLAGE,  # 騎士村 (1)
	BARRIER_VILLAGE, # 結界村 (2)
	MAGE_VILLAGE,    # 魔導村 (3)
	ARCHER_VILLAGE,  # 弓士村 (4)
	SHRINE,          # 神殿 (5)
	WASTELAND,       # 荒野 (6)
	FOREST,          # 森 (7)  🌟NEW!
	MOUNTAIN,        # 山 (8)  🌟NEW!
	ISLAND           # 孤島 (9) 🌟NEW!
}

# ☣️ 毒沼ダメージ深度フェーズ
enum MudPhase {
	NONE,
	LIGHT,  # 3分〜 (2ダメ/秒)
	MEDIUM, # 6分〜 (5ダメ/秒)
	HEAVY   # 9分〜 (10ダメ/秒)
}

# 👑 コシアム5大分岐ルート識別子
enum MatchRoute {
	NORMAL,          # 0: 通常ルート (生存2〜14人)
	TYRANT,          # 1: 暴君ルート (生存1人)
	EARLY_DEAD,      # 2: 早期全滅ルート (10分未満で全滅)
	DESPAIR,         # 3: 絶望ルート (10分到達時に生存0人)
	MIRACLE_DESPAIR, # 4: 奇跡の野良全員生存ルート (生存15人 ＆ 野良) ➔ ⑤-A
	GUILD_RAID       # 5: ギルド統率レイドルート (生存15人 ＆ ギルド) ➔ ⑤-B
}

# 👑 グリッチ称号階層定義パケット (仕様書 v1.1 準拠)
enum GlitchTier {
	TIER1,             # ‡灰燼の‡調律者
	TIER2,             # 灰燼𝔬𝔣𝔱𝔥𝔢𝔗𝔲𝔫𝔢𝔯
	TIER3_VIOLENCE,    # 𝖀𝖓眷𝖓𝖔𝖜𝖓_𝕭𝖊𝖆𝖘𝖙 (第1級特異点)
	TIER3_INTELLECT    # ∅ノ極̷点̷ (零ノ極点)
}
