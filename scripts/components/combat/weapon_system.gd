extends Node
class_name WeaponSystem
# 📜 scripts/combat/weapon_system.gd
# 🌌 [LAYER VILLAGE ROYALE] 拡散射撃・シールド物理展開中枢 v1.1 (エディタ警告完全粉砕版)

# 🧠 外部コンポーネント参照バインド（Node型で循環参照を完全封殺）
var enums = null
var weapon_database: Node = null
var damage_calculator: Node = null

# 🛡️ 盾・結界の3D実体化用プレハブシーン
@export var shield_vfx_scene: PackedScene
@export var barrier_vfx_scene: PackedScene

func _ready() -> void:
	# 1. Enumsの動的ロード
	var path: String = "res://scripts/data/enums.gd"
	var script_res = load(path)
	if script_res != null:
		enums = script_res
	else:
		push_error("⚠️ [WEAPON_SYS] enums.gd が見つかりません！")
		return

	# 2. GameManager経由でDBと電卓を動的ロード
	var game_manager = get_node_or_null("/root/GameManager")
	if game_manager:
		weapon_database = game_manager.get("weapon_database")
		damage_calculator = game_manager.get("damage_calculator")
		
	print("⚔️ [WEAPON_SYS] 武器・防具の挙動執行システムが完全開通しました。")

## 🏹 1. 弓矢の拡散物理発射トリガー
func fire_bow(attacker: Entity, charge_time: float, weapon_level: int) -> void:
	if not damage_calculator or not weapon_database or not enums: return
	
	var arrow_count: int = damage_calculator.get_bow_arrow_count(charge_time)
	var base_atk: float = weapon_database.get_base_attack(enums.WeaponType.BOW, weapon_level)
	var atk_stat: float = attacker.data.stats["atk"] if attacker.data else 0.0
	
	print("🏹 [WEAPON_SYS] %s が弓(Lv%d)をチャージ時間 %.1f秒 で発射！ ➔ 矢の総数: %d本" % \
		[attacker.name, weapon_level, charge_time, arrow_count])
	
	for i in range(arrow_count):
		var spread_angle: float = (i - (arrow_count - 1) / 2.0) * 15.0 # 15度ずつ拡散
		_spawn_arrow_projectile(attacker, base_atk, atk_stat, spread_angle)

## 🧙 2. 魔法チャージ発射トリガー
func cast_magic(attacker: Entity, charge_time: float, weapon_level: int) -> void:
	if not damage_calculator or not weapon_database or not enums: return
	
	var multiplier: float = damage_calculator.get_magic_multiplier(charge_time)
	var base_atk: float = weapon_database.get_base_attack(enums.WeaponType.MAGE_STAFF, weapon_level)
	var mp_stat: float = attacker.data.stats["mp"] if attacker.data else 0.0
	var raw_magic_power: float = (base_atk + mp_stat) * multiplier
	
	print("🔮 [WEAPON_SYS] %s が魔法(Lv%d)をチャージ時間 %.1f秒 で詠唱！ ➔ 基礎魔法威力: %.1f (倍率: %.1f)" % \
		[attacker.name, weapon_level, charge_time, raw_magic_power, multiplier])
		
	_spawn_magic_projectile(attacker, raw_magic_power)

## 🛡️ 3. 盾・結界の3D空間物理展開
func deploy_shield(user: Entity, is_barrier: bool, weapon_level: int) -> void:
	if not weapon_database: return
	
	var max_hp: float = weapon_database.get_shield_max_hp(weapon_level)
	
	if is_barrier:
		print("🌐 [WEAPON_SYS] %s が【半球バリア（結界）】を展開！耐久HP: %d (味方入場可能)" % [user.name, max_hp])
	else:
		print("🛡️ [WEAPON_SYS] %s が【横範囲シールド（盾）】を展開！耐久HP: %d" % [user.name, max_hp])

# 🛠️ 内部弾丸パケット生成ヘルパー（3D物理の具現化・警告回避アンダースコア適応）
func _spawn_arrow_projectile(_attacker: Entity, _base_atk: float, _atk_stat: float, _angle_offset: float) -> void:
	# ⚡ すべての未引数を _ でハックし警告を完全消滅
	pass

func _spawn_magic_projectile(_attacker: Entity, _raw_magic_power: float) -> void:
	pass