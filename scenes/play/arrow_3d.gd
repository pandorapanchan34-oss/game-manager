extends Area3D
# 📜 res://scenes/play/arrow_3d.gd
# 🌌 [LAYER VILLAGE ROYALE] 最小限のアクション物理判定（矢・MVP版）

@export var speed: float = 20.0 # 弾速 (m/s)
var damage_amount: float = 25.0 # 基本攻撃力

func _ready() -> void:
	# 📡 物理的な「侵入検知シグナル」を自身の関数に結線
	body_entered.connect(_on_body_entered)
	
	# 🕒 空間のゴミにならないよう、3秒後に自動パージする安全弁
	get_tree().create_timer(3.0).timeout.connect(queue_free)

func _physics_process(delta: float) -> void:
	# 🧭 自身の「前方ベクトル（-global_transform.basis.z）」に向かってカッ飛ぶ！
	global_position += -global_transform.basis.z * speed * delta

func _on_body_entered(body: Node3D) -> void:
	# 🛡️ 自分自身（プレイヤー）への誤爆をパージ
	if body is Player: 
		return
		
	print("🎯 [ARROW] 物理衝突を検知 ➔ 対象: ", body.name)
	
	# 🤖 相手が Entity 基盤（機神兵やエネミー）の肉体を持っているか検知
	if body.has_method("take_damage"):
		body.take_damage(damage_amount)
		
	# 💥 何かに当たったら矢パケットは役割を終えて消滅
	queue_free()
