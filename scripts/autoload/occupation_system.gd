extends Node
# 📜 scripts/data/occupation_system.gd
# 🌌 [LAYER VILLAGE ROYALE] OccupationSystem v1.5 (5+5+2構造・看破採点完全調律版)

# 🧱 1. 概念・IDの定義
enum MainJobID { WARRIOR, KNIGHT, MAGE, PRIEST, ARCHER }
enum SubJobID { GUARDIAN, PHANTOM, BERSERKER, VAGABOND, SAGE, NINJA, DRAGOON }
enum Season { SEASON_1, SEASON_2 }

const CURRENT_SEASON = Season.SEASON_1

# 📊 2. 恒久不変のコアデータ（メイン100固定）
const MAIN_JOB_STATS = {
	MainJobID.WARRIOR: { "atk": 100, "def": 0, "mdef": 0, "mp": 0, "spd": 0 },
	MainJobID.KNIGHT:  { "atk": 0, "def": 100, "mdef": 0, "mp": 0, "spd": 0 },
	MainJobID.MAGE:    { "atk": 0, "def": 0, "mdef": 0, "mp": 100, "spd": 0 },
	MainJobID.PRIEST:  { "atk": 0, "def": 0, "mdef": 100, "mp": 0, "spd": 0 },
	MainJobID.ARCHER:  { "atk": 0, "def": 0, "mdef": 0, "mp": 0, "spd": 100 }
}

# 📊 3. サブ職業データ（固定5種 + 今期シーズン枠2種 / 全て50配分厳守）
const SUB_JOB_STATS = {
	# 【固定サブ5種】
	SubJobID.GUARDIAN:  { "sub_atk": 0, "sub_def": 50, "sub_mdef": 0, "sub_mp": 0, "sub_spd": 0 },
	SubJobID.PHANTOM:   { "sub_atk": 0, "sub_def": 0, "sub_mdef": 0, "sub_mp": 50, "sub_spd": 0 },
	SubJobID.BERSERKER: { "sub_atk": 50, "sub_def": 0, "sub_mdef": 0, "sub_mp": 0, "sub_spd": 0 },
	SubJobID.VAGABOND:  { "sub_atk": 0, "sub_def": 0, "sub_mdef": 0, "sub_mp": 0, "sub_spd": 50 },
	SubJobID.SAGE:      { "sub_atk": 0, "sub_def": 0, "sub_mdef": 50, "sub_mp": 0, "sub_spd": 0 },
	
	# 【S1限定・シーズンサブ2種】（ハイブリッド配分）
	SubJobID.NINJA:    { "sub_atk": 10, "sub_def": 0, "sub_mdef": 0, "sub_mp": 10, "sub_spd": 30 },
	SubJobID.DRAGOON:  { "sub_atk": 35, "sub_def": 15, "sub_mdef": 0, "sub_mp": 0, "sub_spd": 0 }
}

var registry: Dictionary = {}

## 🛠️ プレイヤーパケット登録（サブ公開 / メイン隠匿）
func register_player(id: String, player_name: String, main_job: MainJobID, sub_job: SubJobID) -> void:
	var main_stats = MAIN_JOB_STATS[main_job]
	var sub_stats = SUB_JOB_STATS[sub_job]
	
	# 裏計算（メイン100 + サブ50）のロジックは絶対維持
	var final_stats = {
		"atk": main_stats["atk"] + sub_stats["sub_atk"],
		"def": main_stats["def"] + sub_stats["sub_def"],
		"mdef": main_stats["mdef"] + sub_stats["sub_mdef"],
		"mp": main_stats["mp"] + sub_stats["sub_mp"],
		"spd": main_stats["spd"] + sub_stats["sub_spd"]
	}
	
	registry[id] = {
		"name": player_name,
		"main_job": main_job, # 🔑 こっちが隠匿される本性（真実）
		# "fake_job": main_job, # 👁️ 自己申告する「表の顔」。v2で対応。
		"sub_job": sub_job,   # 👁️ こっちが常時一般公開される「表向きのスタイル」
		"stats": final_stats,
		"reputation": { "trust": 100, "betrayal": 0, "charisma": 10, "dread": 0 } # 4軸パラメータ
	}
	
	print("👥 [パケット生成] ID: %s | 公開スタイル(サブ): %s ➔ (本性は隠蔽されました)" % [
		player_name, SubJobID.keys()[sub_job]
	])

## 🛠️ プレイヤーパケット登録 v2（サブ公開 / メイン隠匿 / 偽装申告）
func register_player_v2(id: String, player_name: String, main_job: MainJobID, sub_job: SubJobID, fake_job: MainJobID) -> void:
	var main_stats = MAIN_JOB_STATS[main_job]
	var sub_stats = SUB_JOB_STATS[sub_job]
	
	# 裏計算（メイン100 + サブ50）のロジックは絶対維持
	var final_stats = {
		"atk": main_stats["atk"] + sub_stats["sub_atk"],
		"def": main_stats["def"] + sub_stats["sub_def"],
		"mdef": main_stats["mdef"] + sub_stats["sub_mdef"],
		"mp": main_stats["mp"] + sub_stats["sub_mp"],
		"spd": main_stats["spd"] + sub_stats["sub_spd"]
	}
	
	registry[id] = {
		"name": player_name,
		"main_job": main_job, # 🔑 隠匿される本性（真実）
		"fake_job": fake_job, # 👁️ 自己申告する「表の顔」
		"sub_job": sub_job,   # 👁️ 常時一般公開される「表向きのスタイル」
		"stats": final_stats,
		"reputation": { "trust": 100, "betrayal": 0, "charisma": 10, "dread": 0 } # 4軸パラメータ
	}
	
	print("👥 [v2パケット生成] %s | 公開(サブ):%s, 偽装(メイン):%s ➔ (本性は隠蔽)" % [
		player_name, SubJobID.keys()[sub_job], MainJobID.keys()[fake_job]
	])

## 🎯 相手の本職を「こいつはこれだ！」と勝手に予想してマークする（中盤の推理フェーズ）
func record_prediction(my_player_id: String, target_player_id: String, predicted_job: int) -> void:
	if not registry.has(my_player_id) or not registry.has(target_player_id): return
	
	if not registry[my_player_id].has("job_predictions"):
		registry[my_player_id]["job_predictions"] = {}
		
	registry[my_player_id]["job_predictions"][target_player_id] = predicted_job
	
	print("👁️ [OCC_SYS] 予想パケット記録：ID %s が ID %s の本職を【%s】とマークしました。" % [
		my_player_id, target_player_id, MainJobID.keys()[predicted_job]
	])

## ⚡ 【TRUTH REVEALED】時に呼び出す、看破（答え合わせ）判定関数
func evaluate_predictions(my_player_id: String) -> int:
	if not registry.has(my_player_id) or not registry[my_player_id].has("job_predictions"):
		return 0
		
	var my_predictions: Dictionary = registry[my_player_id]["job_predictions"]
	var correct_count: int = 0
	
	print("\n📊 ─── 答え合わせ（%s の看破マトリクス） ───" % registry[my_player_id]["name"])
	for target_id in my_predictions:
		if registry.has(target_id):
			var predicted_job: int = my_predictions[target_id]
			var actual_job: int = registry[target_id]["main_job"]
			var target_name: String = registry[target_id]["name"]
			
			if predicted_job == actual_job:
				correct_count += 1
				print("🎯 【的中】 %s の本職 ➔ 予想: %s | 真実: %s" % [target_name, MainJobID.keys()[predicted_job], MainJobID.keys()[actual_job]])
			else:
				print("❌ 【ハズレ】 %s の本職 ➔ 予想: %s | 真実: %s" % [target_name, MainJobID.keys()[predicted_job], MainJobID.keys()[actual_job]])
				
	print("📈 看破成功数: %d 件（Q.E.D.）" % correct_count)
	return correct_count

## ⚡ 10. TRUTH REVEALED（隠されていたメイン職業＝本性を剥ぎ取る）
func reveal_all_truths() -> void:
	print("\n[SYSTEM] ─── 世界整合システム ───")
	print("「……虚偽情報を破棄。実データを公開。」")
	print("「──真実を開示します。」\n")
	
	print("⚡ ─── TRUTH REVEALED (本性の暴露) ─── ⚡")
	for id in registry:
		var p = registry[id]
		# 過去バージョンとの互換性のため、fake_jobがなければmain_jobで代用
		var fake_job_str = MainJobID.keys()[p.get("fake_job", p["main_job"])]
		
		print("👤 [%s]" % p["name"])
		print(" ➔ 【公開スタイル(サブ)】: %s" % SubJobID.keys()[p["sub_job"]])
		print(" ➔ 【自己申告(フェイク)】: %s" % fake_job_str)
		print(" ➔ 🚨【剥ぎ取られた本性(メイン)】: %s !!!" % MainJobID.keys()[p["main_job"]])
	print("────────────────────────────────────────")
	
	# 🌟 全員の「勝手に予想」を自動で一斉に答え合わせ執行
	print("\n🧠 ─── 全生存者・看破スコア自動集計 ───")
	for id in registry:
		evaluate_predictions(id)
	print("────────────────────────────────────────\n")
	
	# 📡 登録データを添えてSignalBusへ一斉送出！UIや演出カメラがこれに同期します
	var signal_bus = get_node_or_null("/root/SignalBus")
	if signal_bus and signal_bus.has_method("trigger_truth_revealed"):
		signal_bus.trigger_truth_revealed(registry)

## 🔮 外界（Entityなど）から特定のプレイヤーデータを安全に呼び出すパケットフィルター
func get_player_registry(id: String) -> Dictionary:
	if registry.has(id):
		return registry[id]
	return {}