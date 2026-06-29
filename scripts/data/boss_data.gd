extends RefCounted
class_name BossData
# 📜 scripts/data/boss_data.gd
# 🌌 [LAYER VILLAGE ROYALE] コロシアムの番人・神域数理ステータス v1.0

var boss_name: String = "コロシアムの番人"
var max_hp: float = 100.0
var current_hp: float = 100.0
var is_pandora_form: bool = false # 🌟神域パンドラフォームフラグ

## ⚡ 10分00秒：転送時の生存人数からボスの耐久パケットを動的合成する（仕様書 v0.5 準拠）
func configure_boss_stats(alive_count: int, is_tyrant_route: bool = false) -> void:
	# 🌟 ① 暴君ルートの場合：HP30固定・神速即死形態（仕様書 v0.5 第10条）
	if is_tyrant_route:
		boss_name = "番人・神速即死形態"
		max_hp = 30.0
		current_hp = 30.0
		print("🚨 [BOSS_DATA] 暴君ルート執行。番人は【30固定・神速即死形態】で降臨します。")
		return

	# 🌟 ② 15人全員生存時：【神域パンドラフォーム】（HP15000・通常の10倍・即死属性）
	if alive_count >= 15:
		boss_name = "【神域】パンドラフォーム"
		is_pandora_form = true
		max_hp = 15000.0 # 通常の10倍
		current_hp = 15000.0
		print("🌌 [BOSS_DATA] RESONANCE MAX：15人全員生存を検知！【神域パンドラフォーム】顕現。HP: 15000！")
	else:
		# 🌟 ③ 通常/早期全滅ルート：HP = 生存人数 × 100
		is_pandora_form = false
		max_hp = float(alive_count * 100)
		current_hp = max_hp
		print("⚔️ [BOSS_DATA] 通常降臨。生存者数 %d 人 ➔ 番人HP: %d" % [alive_count, max_hp])

## 💥 被弾処理パケット
func take_damage(amount: float) -> void:
	current_hp = max(0.0, current_hp - amount)
	print("👹 [%s] 被弾：残りHP -> %d / %d" % [boss_name, current_hp, max_hp])