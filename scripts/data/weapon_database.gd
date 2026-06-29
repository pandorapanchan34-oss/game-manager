extends Node
# 📜 scripts/data/weapon_database.gd
# 🌌 [LAYER VILLAGE ROYALE] 武器・防具データベース v1.0

# 🧠 動的バインド用
var enums = null

# 📊 武器攻撃力マトリクス（仕様書 v0.5 準拠）
# 弓：Lv1=2 / Lv2=4 / Lv3=5
# その他：Lv1=10 / Lv2=20 / Lv3=30
const WEAPON_ATK_TABLE = {
	"BOW": {1: 2.0, 2: 4.0, 3: 5.0},
	"OTHER": {1: 10.0, 2: 20.0, 3: 30.0}
}

func _ready() -> void:
	# グローバル定数インフラ（enums.gd）を動的バインド
	var path: String = "res://scripts/data/enums.gd"
	var script_res = load(path)
	if script_res != null:
		enums = script_res
	else:
		push_error("⚠️ [WEAPON_DB] enums.gd が見つかりません！")
		return
	print("⚔️ [WEAPON_DB] 武器・防具マスターデータが正常にデプロイされました。")

## 🏹 武器タイプとレベルから基礎攻撃力をパケット回収する（仕様書 v0.5 準拠）
func get_base_attack(weapon_type: int, level: int) -> float:
	if not enums: return 0.0
	
	# レベルの安全弁（Lv1〜3の範囲にクランプ）
	var lv: int = clampi(level, 1, 3)
	
	# 弓かそれ以外かで基礎攻撃力を分岐抽出
	if weapon_type == enums.WeaponType.BOW:
		return WEAPON_ATK_TABLE["BOW"][lv]
	elif weapon_type == enums.WeaponType.NONE:
		return 0.0
	else:
		return WEAPON_ATK_TABLE["OTHER"][lv]

## 🛡️ 盾・結界の最大耐久HPを逆算する（仕様書 v0.5 準拠）
## 公式：耐久HP = Lv × 10
func get_shield_max_hp(level: int) -> float:
	var lv: int = clampi(level, 1, 3)
	return float(lv * 10) # Lv1=10, Lv2=20, Lv3=30(パンドラ)

## 🌌 指定された武器が世界に1本だけの「パンドラ武器（Lv3）」か判定する
func is_pandora_weapon(level: int) -> bool:
	return level == 3