extends Node
class_name PlayerInput
# 📜 scripts/core/player_input.gd
# 🌌 [LAYER VILLAGE ROYALE] PlayerInput v5.0 (共通入力特化神経網)

# 📢 各種HUD・肉体（Player）に伝えるための電波シグナル
signal action_triggered(action_name: String, extra_data: Dictionary)

func _process(_delta: float) -> void:
	# 👻 【防壁】もし親のPlayerDataでゴースト状態でも、入力神経自体は100%維持（修行用）
	
	# 🏃 0. 回避ステップの瞬間検知（例: ui_select = スペースキー等に割り当て）
	if Input.is_action_just_pressed("ui_select"):
		action_triggered.emit("evade", {})

## 🕹️ プレイヤーの移動方向を2Dベクトルとしてパケット回収（player.gdから毎フレーム呼ばれる）
func get_movement_direction() -> Vector2:
	var input_dir := Vector2.ZERO
	input_dir.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_dir.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	if input_dir.length() > 1.0:
		input_dir = input_dir.normalized()
		
	return input_dir
