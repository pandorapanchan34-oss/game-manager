extends BaseJob
class_name SwordJob

func handle_process(delta: float):
	# ⚔️ 剣の連続長押し処理
	if Input.is_action_pressed("ui_text_submit"): # 例: 近接用の別割り当て（任意）
		# 長押しされている間、「斬撃パルス」を毎フレーム連射
		action_triggered.emit("sword_hold", {"delta": delta})
	elif Input.is_action_just_released("ui_text_submit"):
		action_triggered.emit("sword_released", {})
