extends BaseJob
class_name MageJob

var mage_charge_time: float = 0.0

func handle_process(delta: float):
	# 🔮 魔法のチャージ処理 (最大7秒)
	if Input.is_action_pressed("ui_focus"): # 例: Shiftキー
		mage_charge_time = min(7.0, mage_charge_time + delta)
		charge_updated.emit("mage", mage_charge_time)
	elif Input.is_action_just_released("ui_focus"):
		_execute_mage_shot()
		mage_charge_time = 0.0
		charge_updated.emit("mage", mage_charge_time)

func _execute_mage_shot():
	var multiplier: float = 0.5
	if mage_charge_time >= 7.0: multiplier = 2.0
	elif mage_charge_time >= 3.0: multiplier = 1.0
	
	print("🔮 [JOB:MAGE] 魔法発射パルス: 倍率 %.1f 倍 (チャージ: %.1fs)" % [multiplier, mage_charge_time])
	action_triggered.emit("mage_shoot", {"multiplier": multiplier})
