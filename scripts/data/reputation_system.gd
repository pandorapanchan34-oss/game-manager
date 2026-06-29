extends Node
# 📜 scripts/data/reputation_system.gd
# 🌌 [LAYER VILLAGE ROYALE] ReputationSystem v1.1 (4軸カルマ・特権監視網)

# 🧠 動的バインド
var occupation_system: Node = null

func _ready() -> void:
	# 常駐している OccupationSystem からレジストリを書き換えるためのパスを確保
	var game_manager = get_node_or_null("/root/GameManager")
	if game_manager:
		occupation_system = game_manager.get("occupation_system")
	print("🧠 [REPUTATION_SYS] 4軸カルマ追跡マトリクスが正常に固定されました。")

## 📊 行動パケットに応じて4軸パラメータを変動させる（仕様書 v0.70 厳守）
func alter_reputation(player_id: String, axis_name: String, amount: float) -> void:
	# オートロード、またはGameManager経由でOccupationSystemを取得
	var occ_sys = occupation_system if occupation_system else get_node_or_null("/root/OccupationSystem")
	if not occ_sys: return
	
	var registry = occ_sys.get("registry")
	if not registry or not registry.has(player_id): return
	
	var rep: Dictionary = registry[player_id]["reputation"]
	if rep.has(axis_name):
		rep[axis_name] = clamp(rep[axis_name] + amount, 0.0, 100.0)
		print("🧠 [REPUTATION] ID:%s の カルマ変異 ➔ %s: %.1f (増減: %.1f)" % [player_id, axis_name, rep[axis_name], amount])
		
		# 🦹 特権アンロックの閾値判定
		_evaluate_karma_thresholds(player_id, rep)

func _evaluate_karma_thresholds(player_id: String, rep: Dictionary) -> void:
	if rep["dread"] >= 80.0:
		print("🚨 [REPUTATION] 警告：ID:%s の【畏怖】が80を突破。『賞金首パケット』が強制バインドされました。" % player_id)
	if rep["charisma"] >= 75.0:
		print("🎭 [REPUTATION] 特権：ID:%s の【カリスマ】が75を突破。『フェイク・シグナル』の権限が開通。" % player_id)