extends Control
class_name HUD
# 📜 scripts/ui/hud.gd
# 🌌 [LAYER VILLAGE ROYALE] 網膜情報同期・画面描画中枢 v1.5 (Enum分離・シグナル完全調律版)

# 🎨 UIノード参照パケット
@onready var time_label: Label = $TimerContainer/TimeLabel
@onready var hp_bar: TextureProgressBar = $StatusContainer/HPBar
@onready var mp_bar: TextureProgressBar = $StatusContainer/MPBar
@onready var charge_bar: TextureProgressBar = $StatusContainer/ChargeBar
@onready var announcement_panel: ColorRect = $AnnouncementPanel
@onready var announcement_label: Label = $AnnouncementPanel/TypewriterLabel

# 🧠 動的バインド用
var game_manager: Node = null

func _ready() -> void:
	# 📡 SignalBusの電波帯域にUIを直結
	var signal_bus = get_node_or_null("/root/SignalBus")
	if signal_bus:
		signal_bus.mud_warning_triggered.connect(func(_idx): pass)
		signal_bus.private_whisper_received.connect(func(_id, _idx): pass)
		
		# 🌟 システム側の発火名（trigger_truth_revealed）と完全に同期・バインド
		if signal_bus.has_signal("trigger_truth_revealed"):
			signal_bus.trigger_truth_revealed.connect(_on_truth_revealed_triggered)
	
	# GameManager のインスタンスを回収
	game_manager = get_node_or_null("/root/GameManager")
	
	# 🎭 アナウンスパネルは最初完全に隠蔽
	announcement_panel.visible = false
	announcement_panel.modulate.a = 0.0
	
	print("👁️ [HUD] 網膜同期インターフェース、描写スタンバイ。全シグナル結線完了。")

func _process(_delta: float) -> void:
	# 🕒 1. GameManagerからリアルタイムの試合時間を引き抜いてUIを更新
	if game_manager:
		var current_time: float = game_manager.get("match_timer")
		_update_timer_display(current_time)
		
	# 🧪 2. ローカルプレイヤーの生存ステータスを動的追従
	_update_player_status_mock()

## 🕒 試合残り時間のカウントダウン描画（15分制 ➔ 10分時点でタイマーの色彩を赤へ変異）
func _update_timer_display(elapsed_seconds: float) -> void:
	if not time_label: return
	
	# 全体の残り時間を計算（15分 = 900秒）
	var total_duration: float = 900.0
	var remaining_time: float = max(0.0, total_duration - elapsed_seconds)
	
	var minutes: int = int(remaining_time / 60.0)
	var seconds: int = int(remaining_time) % 60
	
	# ⏳ 10分（経過600秒）を超過するとタイマーが「警告赤」へ変異する演出
	if elapsed_seconds >= 600.0:
		time_label.add_theme_color_override("font_color", Color.RED)
		time_label.text = "🚨 TRUTH REVEALED: %02d:%02d" % [minutes, seconds]
	else:
		time_label.text = "%02d:%02d" % [minutes, seconds]

## 🤫 9分55秒：世界整合アナウンス演出の執行
func _on_world_alignment_announced() -> void:
	print("🔇 [HUD] 世界整合アナウンスの電波を受信。全画面暗転・無音タイプライターを開始します。")
	
	announcement_panel.visible = true
	
	# 🎬 画面を冷徹に暗転させる
	var tween = create_tween()
	tween.tween_property(announcement_panel, "modulate:a", 1.0, 1.5).set_trans(Tween.TRANS_LINEAR)
	tween.tween_callback(_start_typewriter_text)

## ✍️ 暗転後のタイプライター演出（仕様書 v1.0 「6. 世界整合アナウンス」完全シミュレート）
func _start_typewriter_text() -> void:
	if not announcement_label: return
	
	# 仕様書の文字列をそのまま展開
	var full_text: String = "……検知。\n\n本マッチにおける絆の残存を、私は嫌悪する。\n今より、世界整合システムが審判を下す。\n\n嘘をついた者よ。真実は既に知っている。\n信じた者よ。その選択の重さを、今から証明してみせろ。\n\n全生存者をコロシアムへ。\n\n――真実を、暴け。"
	announcement_label.text = ""
	
	# 1文字ずつ浮かび上がらせる文字送り執行
	for char_item in full_text:
		announcement_label.text += char_item
		await get_tree().create_timer(0.05).timeout # 文字数が多いため0.05秒にテンポを微調整

## 🚨 10分00秒：欺瞞解除（TRUTH REVEALED）の執行
func _on_truth_revealed_triggered(_registry_data: Dictionary) -> void:
	print("💥 [HUD] TRUTH REVEALED 演出執行！画面の目隠しを解除し、強制転送後の視界を確保。")
	
	var tween = create_tween()
	tween.tween_property(announcement_panel, "modulate:a", 0.0, 2.0).set_trans(Tween.TRANS_SINE)
	tween.tween_callback(func(): announcement_panel.visible = false)

## 🎯 UIのプレイヤー一覧ボタンやNPCリストから呼び出される入力中継ブリッジ
func select_job_prediction_via_ui(target_id: String, predicted_job_id: int) -> void:
	var my_id: String = "local_player"
	
	var occ_sys = get_node_or_null("/root/OccupationSystem")
	if occ_sys and occ_sys.has_method("record_prediction"):
		occ_sys.record_prediction(my_id, target_id, predicted_job_id)
		_show_prediction_toast_vfx(target_id, predicted_job_id)

## 🎨 画面上のマーク完了ビジュアル演出
func _show_prediction_toast_vfx(target_id: String, predicted_job_id: int) -> void:
	var occ_sys = get_node_or_null("/root/OccupationSystem")
	if not occ_sys: return
	
	# 🔑 JobID ➔ MainJobID のキー配列へ修正完了（Q.E.D.）
	var job_name: String = occ_sys.MainJobID.keys()[predicted_job_id]
	print("👁️ [HUD_VFX] 画面上に看破ロックオンマーカーを展開：対象[%s] ➔ 予想枠:[%s]" % [target_id, job_name])

## 🛠️ モックアップ用ステータス更新
func _update_player_status_mock() -> void:
	if hp_bar: hp_bar.value = 100
	if mp_bar: mp_bar.value = 50
	if charge_bar: charge_bar.value = 0
