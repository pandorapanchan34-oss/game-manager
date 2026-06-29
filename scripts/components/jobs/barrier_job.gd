extends BaseJob
class_name BarrierJob

func handle_process(_delta: float):
	# 🔮 5. 結界の展開（単発発動）
	if Input.is_action_just_pressed("ui_menu"): # 例: 特定のキー
		action_triggered.emit("barrier_burst", {})
