extends BaseJob
class_name ShieldJob

func handle_process(delta: float):
	# 🛡️ 盾の展開（ホールド制御）
	if Input.is_action_pressed("ui_cancel"): # 例: Escキーや右クリック等を想定
		action_triggered.emit("shield_hold", {})
	elif Input.is_action_just_released("ui_cancel"):
		action_triggered.emit("shield_released", {})
