extends Node
# 📜 scripts/data/economy_manager.gd
# ⚙️ [LAYER VILLAGE ROYALE] 歯車・時計エコノミー中枢 v1.0

signal economy_updated

# 🪙 プレイヤーの所持通貨パケット
var rusted_gears: int = 0  # 錆びた歯車 (NPC狩り + 報酬)
var silver_gears: int = 0  # 銀の歯車 (試合報酬のみ)

## 🛢️ 死後NPC撃破時のドロップ執行
func add_rusted_gear_from_npc() -> void:
	rusted_gears += 1
	print("⚙️ [ECONOMY] 機械敵を破壊！『錆びた歯車』を1個回収しました。（現在: %d 個）" % rusted_gears)
	economy_updated.emit()

## 🎰 ガチャ（時計）の執行パルス
func spin_clock_gacha(gacha_type: String) -> Dictionary:
	match gacha_type:
		"RUSTED":
			if rusted_gears >= 10: # 例えば10個で1回
				rusted_gears -= 10
				print("⏳ [GACHA] 錆びた時計ガチャを回しました（ショボ報酬スキン・バフ無）")
				return {"result": "COMMON_SKIN", "buff": false}
		"SILVER":
			if silver_gears >= 5:
				silver_gears -= 5
				print("🥈 [GACHA] 銀時計ガチャを回しました（職業グレードアップスキン・バフ無）")
				return {"result": "ELITE_SKIN", "buff": false}
	
	print("⚠️ [ECONOMY] 歯車が足りません！")
	return {"result": "NONE", "buff": false}