extends RefCounted
class_name PlayerData

# 🪐 グローバルなAutoloadとの衝突をパージするため、インナークラス名を「PlayerEnums」へシフト
class PlayerEnums:
	enum MainOccupation { WARRIOR, KNIGHT, BARRIERIST, MAGE, ARCHER }
	enum SubOccupation { NINJA, DRAGOON, MACHINIST, BARD }
	enum ApparentFace { WANDERER }

# 🔁 既存コードのドット参照（enums.MainOccupation...）を破壊しないためのエイリアス結線
const enums = PlayerEnums

# 📜 scripts/data/player_data.gd
# 🌌 [LAYER VILLAGE ROYALE] 3層欺瞞・4軸人格データパケット v1.2 (Autoload衝突パージ＆ゴースト適合)

# 🆔 基本識別パケット
var player_id: String = ""
var player_name: String = ""
var is_ai: bool = false

# 👻 【ゴーストフェーズ拡張】霊体化状態を記憶する因果のフラグ
var is_ghost: bool = false

# 🎭 3層の欺瞞構造 (仕様書 v1.0 準拠)
var main_occupation: int = enums.MainOccupation.WARRIOR     # Layer3: 完全非公開 (TRUTH REVEALEDまで隠蔽)
var apparent_face: int = enums.ApparentFace.WANDERER        # Layer2: 表の顔 (自己申告・偽装可能)
var sub_occupation: int = enums.SubOccupation.NINJA         # Layer1: サブ職業 (シーズン制・全員に公開)

# 📡 【GhostManager結線用】現在のメイン職業を文字列パケットとして安全に一本釣りするゲッター
var current_main_job: String:
	get:
		match main_occupation:
			enums.MainOccupation.WARRIOR: return "Warrior"
			enums.MainOccupation.KNIGHT: return "Knight"
			enums.MainOccupation.BARRIERIST: return "Barrierist"
			enums.MainOccupation.MAGE: return "Mage"
			enums.MainOccupation.ARCHER: return "Archer"
		return "Unknown"

# 📊 リアルタイム合成ステータス
var stats := {
	"hp": 100.0,      # 全員100固定・成長なし
	"max_hp": 100.0,
	"atk": 0,
	"def": 0,
	"mdef": 0,
	"mp": 0,
	"spd": 0
}

# 🧠 永久記録・4軸人格パラメータ (拡張仕様 v0.70 準拠)
var trust_score: float = 0.0      # 信頼度 (Trust)
var betrayal_score: float = 0.0   # 裏切り指数 (Betrayal)
var charisma_score: float = 0.0   # カリスマ (Charisma)
var dread_score: float = 0.0      # 畏怖 (Dread)

# 🔍 ブレイン軸集計用
var fake_accuracy_duration: float = 0.0  # 本性がバレなかった時間
var deceit_score: float = 0.0            # 申告と実態の乖離度
var look_through_count: int = 0          # 他者を見破った数
var be_looked_through_count: int = 0     # 自分が見破られた回数

## 🧬 職業ステータスの裏合成ロジック (仕様書 v0.5 準拠)
func calculate_allocated_stats() -> void:
	# 一度初期化
	stats["atk"] = 0
	stats["def"] = 0
	stats["mdef"] = 0
	stats["mp"] = 0
	stats["spd"] = 0
	
	# 1. メイン職業のバインド (能力 +100)
	match main_occupation:
		enums.MainOccupation.WARRIOR:    stats["atk"]  += 100
		enums.MainOccupation.KNIGHT:     stats["def"]  += 100
		enums.MainOccupation.BARRIERIST: stats["mdef"] += 100
		enums.MainOccupation.MAGE:       stats["mp"]   += 100
		enums.MainOccupation.ARCHER:     stats["spd"]  += 100

	# 2. サブ職業のバインド (能力 +50 ※シーズン1忍者は俊敏特化等のカスタム可、基本は仕様書準拠)
	match sub_occupation:
		enums.SubOccupation.NINJA:
			stats["spd"] += 50  # 忍者：俊敏+50
		enums.SubOccupation.DRAGOON:
			stats["atk"] += 50  # 竜騎士：攻撃+50
		enums.SubOccupation.MACHINIST:
			stats["def"] += 50  # 機工士：防御+50
		enums.SubOccupation.BARD:
			stats["mp"]  += 50  # 吟遊詩人：MP+50

## 🎭 欺瞞情報の偽装チェック (フェイク・シグナル用)
func get_visible_profile(_viewer_id: String, is_fake_signal_active: bool = false) -> Dictionary:
	# 通常開示される情報パケット
	var profile = {
		"player_name": player_name,
		"sub_occupation": sub_occupation,
		"apparent_face": apparent_face,
		"trust_rank": _get_trust_rank(),
		"dread_status": dread_score > 80.0 # 一定値超過で賞金首システム
	}
	
	# カリスマA以上の専用能力「フェイク・シグナル」発動時 (仕様書 v0.70 準拠)
	if is_fake_signal_active:
		profile["trust_score_visible"] = 95.0
		profile["betrayal_score_visible"] = 10.0
	else:
		# 通常は非公開だが、特定のシステムバインド用に実数を格納
		profile["trust_score_visible"] = trust_score
		profile["betrayal_score_visible"] = betrayal_score
		
	return profile

func _get_trust_rank() -> String:
	if trust_score >= 90: return "S"
	if trust_score >= 70: return "A"
	if trust_score >= 50: return "B"
	if trust_score >= 30: return "C"
	if trust_score >= 10: return "D"
	return "E"
