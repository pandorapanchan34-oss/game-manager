extends Entity
class_name Player
# 🌌 [LAYER VILLAGE ROYALE] Player v5.0 (BaseJob継承・単一ジョブ動的結合版)

@export var input_path: NodePath
@onready var player_input: PlayerInput = get_node_or_null(input_path)

# ⚔️ 現在右手に宿している唯一のジョブ（本性）
var current_job: BaseJob = null

var damage_timer: Timer

func _ready() -> void:
	super._ready()
	_setup_damage_timer()
	
	# 📡 脳（Input）からの共通アクション（回避など）を受信
	if player_input and player_input.has_signal("action_triggered"):
		player_input.action_triggered.connect(_on_player_input_action)
		
	# ⚔️ 記憶（PlayerData）から本性を暴き、唯一のジョブを動的物質化！
	call_deferred("_attach_job_component")
	
	print("👤 [PLAYER] マスターの3D肉体リンクが完全開通しました。")

func _process(delta: float) -> void:
	# ⚔️ 毎フレームの処理（入力検知やチャージ計算）は、装着中のジョブへ完全丸投げ
	if current_job:
		current_job.handle_process(delta)

func _physics_process(delta: float) -> void:
	if not player_input: return
	
	_check_underfoot_environment()
	
	var move_dir_2d: Vector2 = player_input.get_movement_direction()
	var move_dir_3d := Vector3(move_dir_2d.x, 0.0, move_dir_2d.y).normalized()
	velocity = move_dir_3d * current_speed
	
	super._physics_process(delta)

## ⚔️ 記憶（PlayerData）から「本性」のジョブだけを一本釣りして結合する
func _attach_job_component() -> void:
	if not data: return
		
	var job_name: String = data.current_main_job.to_lower() # "archer", "mage" 等
	var job_path: String = "res://scenes/jobs/%s_job.tscn" % job_name
	
	if ResourceLoader.exists(job_path):
		var job_res = load(job_path)
		var job_instance = job_res.instantiate()
		
		if job_instance is BaseJob:
			current_job = job_instance
			add_child(current_job)
			current_job.initialize(self) # ジョブ側にPlayerの肉体を認識させる
			
			# ジョブ側からの「魔法を撃て」「矢を放て」のシグナルを受信結線
			current_job.action_triggered.connect(_on_job_action_triggered)
			
			print("✨ [PLAYER] 本性ジョブ [%s] の単一結合に成功しました（Q.E.D.）。" % current_job.class_name)
	else:
		print("⚠️ [PLAYER:SIMULATOR] シーン [%s] が未物質化のため、丸腰状態でスタンバイします。" % job_path)

## ⚡️ 共通アクションの受信（回避など）
func _on_player_input_action(action_name: String, _extra_data: Dictionary) -> void:
	if action_name == "evade":
		print("🏃 [PLAYER] 回避ステップを実行！無敵パルス放射。")

## ⚡️ ジョブからの物理執行命令を受信
func _on_job_action_triggered(action_name: String, extra_data: Dictionary) -> void:
	# ここに、矢のプレハブ（tscn）を生成したり、エフェクトを再生する処理を書く
	print("💥 [PLAYER] ジョブからの物理執行パルス '%s' を受信: %s" % [action_name, extra_data])
	
	## 🕒 既存の1秒環境ダメージ精算クロック
func _setup_damage_timer() -> void:
	damage_timer = Timer.new()
	damage_timer.wait_time = 1.0
	damage_timer.one_shot = false
	damage_timer.autostart = true
	damage_timer.timeout.connect(_on_damage_clock_tick)
	add_child(damage_timer)

func _on_damage_clock_tick() -> void:
	if is_in_mud:
		# ※新ディレクトリ構造に合わせて、PoisonSwampManagerのパスは必要に応じて微調整してください
		var swamp_man = get_node_or_null("/root/main/GameManager/PoisonSwampManager")
		if swamp_man and swamp_man.has_method("get_current_mud_damage"):
			var damage = swamp_man.get_current_mud_damage()
			if damage > 0.0:
				take_damage(damage)

## 🐊 既存の足元環境監視
func _check_underfoot_environment() -> void:
	var game_manager = get_node_or_null("/root/main/GameManager")
	if not game_manager: return
	var map_gen = game_manager.get("map_generator")
	if map_gen and map_gen.has_method("get_sector_index_from_position"):
		var flat_pos_2d = Vector2(global_position.x, global_position.z)
		var idx: int = map_gen.get_sector_index_from_position(flat_pos_2d)
		if map_gen.has_method("is_sector_mud"):
			is_in_mud = map_gen.is_sector_mud(idx)

## 👻 【生命反転】ゴーストフェーズへの強制転換（動的プロパティ走査防壁搭載版）
func transition_to_ghost() -> void:
	print("\n👁️👁️👁️ [PLAYER:GHOST] 霊体化シーケンスを開始します。次元位相を反転。")
	
	# 🕒 毒沼タイマーの安全停止
	if damage_timer and damage_timer.is_inside_tree():
		damage_timer.stop()
		
	# 🌐 物理衝突レイヤーの全パージ（霊体化）
	collision_layer = 0
	collision_mask = 0
	
	# 🎨 【マスターの神託：動的リフレクション防壁】
	# 3Dノード（GeometryInstance3Dなど）や2Dノードの違いをすり抜けて安全に半透明化
	var property_list = get_property_list()
	for prop_info in property_list:
		if prop_info.name == "modulate":
			self.set("modulate", Color(1.0, 1.0, 1.0, 0.4)) # アルファ値を0.4にして半透明化
			print("🔮 [PLAYER:GHOST] プロパティ 'modulate' を検知。位相変化（半透明化）に成功。")
			break
	
	# 📡 ゴーストマネージャーへタイムラインの主導権を委譲
	var ghost_man = get_node_or_null("/root/main/GhostManager")
	if ghost_man and ghost_man.has_method("activate_ghost_timeline"):
		ghost_man.activate_ghost_timeline(self)
