extends Node
# 📜 scripts/combat/damage_calculator.gd
# 🌌 [LAYER VILLAGE ROYALE] 物理・魔法ダメージ絶対演算電卓 v1.0

## ⚔️ 1. 物理ダメージ計算（仕様書 v0.5 準拠）
## 公式：物理ダメージ = 基礎攻撃 + (攻撃ステータス × 基礎攻撃 ÷ 100 × 0.5)
##       物理防御カット = 防御ステータス × 0.3（減算）
func calculate_physical_damage(base_atk: float, atk_stat: float, def_stat: float) -> float:
	# 💥 攻撃側：威力のパケット演算
	var raw_damage: float = base_atk + (atk_stat * base_atk / 100.0 * 0.5)
	
	# 🛡️ 防御側：減算カットの執行（仕様書：防御ステータス × 0.3）
	var def_cut: float = def_stat * 0.3
	
	# 最終ダメージ算出（マイナス値になって回復しちゃうバグを最低1ダメージで安全弁固定）
	var final_damage: float = max(1.0, raw_damage - def_cut)
	
	print("⚔️ [CALC_PHYS] 演算執行：Raw %d (カット %d) ➔ 最終適用: %d" % [raw_damage, def_cut, final_damage])
	return final_damage

## 🔮 2. 魔法ダメージ計算（仕様書 v0.5 準拠）
## 公式：物理防御完全無視・魔防のみ参照
##       魔法防御カット = 魔防ステータス × 0.3（減算）
func calculate_magic_damage(raw_magic_power: float, mdef_stat: float) -> float:
	# 💥 魔法はチャージ倍率などを乗算済みの raw_magic_power をそのままベースにする
	# 🛡️ 防御側：魔防減算カットの執行（仕様書：魔防ステータス × 0.3）
	var mdef_cut: float = mdef_stat * 0.3
	
	# 物理防御を完全無視して魔防のみで減算
	var final_damage: float = max(1.0, raw_magic_power - mdef_cut)
	
	print("🔮 [CALC_MAG] 演算執行：魔法威力 %d (魔防カット %d) ➔ 最終適用: %d" % [raw_magic_power, mdef_cut, final_damage])
	return final_damage

## 🎯 3. 弓チャージ発射・矢の総数判定（仕様書 v0.5 準拠）
## 即射➔1本、1.5秒➔3本、3秒フルチャージ➔5本
func get_bow_arrow_count(charge_time: float) -> int:
	if charge_time >= 3.0: return 5  # 3秒フルチャージ
	if charge_time >= 1.5: return 3  # 1.5秒チャージ
	return 1                         # 即射

## 🧙 4. 魔法チャージ倍率判定（仕様書 v0.5 準拠）
## 即射➔0.5倍、3秒➔1.0倍、7秒フルチャージ➔2.0倍
func get_magic_multiplier(charge_time: float) -> float:
	if charge_time >= 7.0: return 2.0  # 7秒フルチャージ
	if charge_time >= 3.0: return 1.0  # 3秒チャージ
	return 0.5                         # 即射