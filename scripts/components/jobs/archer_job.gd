extends BaseJob
class_name ArcherJob
# 📜 scripts/components/jobs/archer_job.gd
# 🌌 [LAYER VILLAGE ROYALE] ArcherJob v6.0 (3D物理物質化・拡散デプロイ形態)

# 🏹 錬成した仮の矢シーンをあらかじめ装填
const ARROW_SCENE: PackedScene = preload("res://scenes/play/Arrow3D.tscn")

var bow_charge_time: float = 0.0

func handle_process(delta: float):
	# 🎯 弓のチャージ処理 (最大3秒)
	if Input.is_action_pressed("ui_accept"): # 例: Enterキーや攻撃ボタン
		bow_charge_time = min(3.0, bow_charge_time + delta)
		charge_updated.emit("bow", bow_charge_time)
	elif Input.is_action_just_released("ui_accept"):
		_execute_bow_shot()
		bow_charge_time = 0.0
		charge_updated.emit("bow", bow_charge_time)

func _execute_bow_shot():
	if not ARROW_SCENE:
		print("⚠️ [JOB:ARCHER] 矢のシーン(ARROW_SCENE)が未装填です。")
		return

	# 🔢 チャージ時間から矢の数を逆算 (1.5秒未満=1本, 3秒未満=3本, 3秒マックス=5本)
	var arrow_count: int = 1
	if bow_charge_time >= 3.0:
		arrow_count = 5
	elif bow_charge_time >= 1.5:
		arrow_count = 3

	print("🏹 [JOB:ARCHER] 弓発射パルス: %d 本 (チャージ: %.1fs)" % [arrow_count, bow_charge_time])
	action_triggered.emit("bow_shoot", {"arrows": arrow_count, "charge": bow_charge_time})

	# 👥 自身の親（Player肉体ノード）を取得
	var parent_node = get_parent()
	if not parent_node: return

	# 🌐 矢を放つ「基準座標（プレイヤーのグローバル座標と回転））
	var base_transform: Transform3D = parent_node.global_transform

	# 📐 拡散射撃の扇形計算（1本なら正面、複数なら左右に角度をバラす）
	# 例: 5本なら -20°, -10°, 0°, 10°, 20° に拡散
	var spread_angle_deg: float = 10.0 # 矢と矢の間の角度
	var start_offset = -(arrow_count - 1) / 2.0

	for i in range(arrow_count):
		# 1本ずつの回転角度を算出
		var current_offset = start_offset + i
		var angle_rad = deg_to_rad(current_offset * spread_angle_deg)

		# 矢のインスタンスを錬成
		var arrow = ARROW_SCENE.instantiate()
		
		# 宇宙（/root/main などのルート戦場）に安全にアタッチ
		var main_scene = get_node_or_null("/root/main")
		if main_scene:
			main_scene.add_child(arrow)
		else:
			player.get_parent().add_child(arrow)

		# 📐 矢の初期位置と「向き（Y軸回転）」を拡散角度に合わせてガチッと固定
		var arrow_transform = base_transform
		arrow_transform = arrow_transform.rotated_local(Vector3.UP, angle_rad)
		
		# ちょいとプレイヤーの目の前（少し上）から出るように微調整
		arrow_transform.origin += -base_transform.basis.z * 1.0 + Vector3.UP * 1.0
		
		arrow.global_transform = arrow_transform
