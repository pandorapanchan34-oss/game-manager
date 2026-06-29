extends Node
class_name NPCBrain
# 📜 scripts/ai/npc_brain.gd
# 🌌 [LAYER VILLAGE ROYALE] 14人の欺瞞・相互推理AIブレイン v1.5 (Q.E.D.マージ版)

# 🧠 依存システム参照パケット（Node型で安全弁確保）
var distance_manager: Node = null
var occupation_system: Node = null
var my_entity: Entity = null

# 🎭 AIの人格偽装パケット（仕様書 v1.0 準拠）
var my_peer_id: String = ""
var fake_identity: String = "旅人" # Layer2: 表の顔
var current_target_pos := Vector3.ZERO

func _ready() -> void:
	my_entity = get_parent() as Entity
	my_peer_id = str(my_entity.name) if my_entity else str(get_instance_id())
	
	# 各種マネージャーの電波をGameManagerから回収
	var game_manager = get_node_or_null("/root/GameManager")
	if game_manager:
		distance_manager = game_manager.get("distance_manager")
		occupation_system = game_manager.get("occupation_system")
		
	# 📡 悪魔の囁き（個別情報）を受信する耳を電波塔に結線
	var signal_bus = get_node_or_null("/root/SignalBus")
	if signal_bus:
		signal_bus.private_whisper_received.connect(_on_whisper_received)
		
	print("🥷 [NPC_BRAIN] AIプレイヤー(%s)の脳細胞が覚醒。仮面【%s】を装着しました。" % [my_peer_id, fake_identity])

func _process(delta: float) -> void:
	if not my_entity or not distance_manager: return
	
	# 🕒 3分ごとに過熱する安全地帯への距離計算と徘徊移動シミュレーション
	_think_movement_strategy(delta)

## 🏃 距離解析を用いた毒沼回避・漁夫の利徘徊ロジック（仕様書 v0.66 / v0.70 準拠）
func _think_movement_strategy(_delta: float) -> void:
	# 🌟 足元が毒沼、またはGameManagerから縮小シグナルが出ているか監視
	if my_entity.is_in_mud:
		# 💡 距離マネージャーを使って、最も近い安全な3D座標（中心点）を逆算して逃げる
		my_entity.velocity = Vector3.FORWARD * my_entity.current_speed
	else:
		# 平時は村や神殿のアイテムを求めて索敵徘徊（仕様書 v0.5 準拠）
		_simulate_tactical_inference()

## 👁️ AIによる周辺環境・他プレイヤーのプロファイリング（相互推理トリガー）
func _simulate_tactical_inference() -> void:
	if not distance_manager or not occupation_system: return
	
	# 🎲 毎フレーム実行すると重いので、低確率（徘徊の合間）で他人のプロファイリングを執行
	if randf() > 0.01: return
	
	# 🧠 登録されている他の生存者パケットを走査
	var registry: Dictionary = occupation_system.get("registry")
	for target_id in registry:
		if target_id == my_peer_id: continue
		
		# 本来は3D実距離や目視判定、今回はモックとして表面上の公開職（サブ）をベースに深層心理を看破
		var target_data = registry[target_id]
		var target_sub_job: int = target_data["sub_job"]
		
		# 内部推論網をキック
		_execute_ai_job_inference(target_id, target_sub_job)

## 🤖 NPCが他プレイヤー（またはマスター）の裏職業を勝手に推理して記憶するAIアルゴリズム
func _execute_ai_job_inference(target_id: String, target_sub_job: int) -> void:
	if not occupation_system: return
	
	var registry: Dictionary = occupation_system.get("registry")
	if not registry.has(my_peer_id): return
	
	# すでにその対象への予想を登録済みの場合は重ねてリソースを割かない
	var my_data = registry[my_peer_id]
	if my_data.has("job_predictions") and my_data["job_predictions"].has(target_id):
		return
		
	# 推理設定：デフォルトは表面上のスタイル（サブ職）と同じ
	var predicted_job: int = target_sub_job
	
	# ⚡ 40%の確率で「こいつの本性は別にある」と見破りモードが発動
	if randf() < 0.4:
		var all_jobs = occupation_system.JobID.values()
		all_jobs.erase(target_sub_job) # 表向きの姿以外の職をあえて裏職としてメタ読みマーク
		predicted_job = all_jobs[randi() % all_jobs.size()]
		
	# 📡 割り出した予想パケットをデータ層へ自律投函！
	occupation_system.record_prediction(my_peer_id, target_id, predicted_job)
	
	var job_name: String = occupation_system.JobID.keys()[predicted_job]
	print("🤖 [NPC_BRAIN:%s] が ID:%s の挙動を凝視している……（脳内予想: %s）" % [my_peer_id, target_id, job_name])

## 🤫 2分30秒：悪魔の囁き（個別嘘情報）を受信した際のAIの心理変異
func _on_whisper_received(peer_id: String, sector_idx: int) -> void:
	if peer_id != my_peer_id: return
	
	# 仕様書 v0.66：届いた個別情報が本当か嘘か疑心暗鬼になるパケット
	print("🥷 [NPC_BRAIN:%s] 悪魔の囁きを受信！『セクター %d が毒沼化する…？』。情報を利用して他チームをハメるか？" % [my_peer_id, sector_idx])