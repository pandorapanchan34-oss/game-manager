extends Control
# 📜 scripts/ui/title.gd
# 🌌 [LAYER VILLAGE ROYALE] タイトル画面・ボタン大復活神経 v2.0 (ハイブリッド分岐版)

# 👑 タイポを完全パージ！%StartButton を寸分の狂いもなく捕捉します
@onready var start_button: Button = %StartButton if has_node("%StartButton") else find_child("StartButton", true, false)

# 🚀 運命の分岐先ゲートの物理パス
const CHARACTER_SELECT_SCENE = "res://scenes/character_select.tscn"
const LOBBY_SCENE = "res://scenes/lobby.tscn"

func _ready() -> void:
	# 💡 安全弁：シーンが消滅しかけている途中の誤作動なら、何もせず即パージ（リターン）
	if is_queued_for_deletion(): 
		return
		
	if not start_button:
		print("❌ [ERROR] Titleシーン内に 'StartButton' が見つかりません！")
		return
		
	# 🔗 多重結線を防ぐため、念のため一度切断してから綺麗にバインド
	if start_button.pressed.is_connected(_on_start_button_pressed):
		start_button.pressed.disconnect(_on_start_button_pressed)
		
	start_button.pressed.connect(_on_start_button_pressed)
	print("📡 [TITLE] 本番結線パルス。StartButtonの接続完了（Q.E.D.）。")

func _on_start_button_pressed() -> void:
	# 💡 超重要：連打による多重ワープ（クラッシュ）を完全に防ぐため、押された瞬間にボタンの入力を完全ロック！
	if start_button:
		start_button.disabled = true
		
	print("🚀 [LAUNCH] ゲート開通！記憶（セーブデータ）を走査中...")
	
	# 💾 【テスト用分岐フラグ】
	# ❌ false のとき ➔ 初回起動として「キャラ選択（character_select.tscn）」へ
	# ⭕ true に書き換えると ➔ 2回目以降として直接「ロビー（lobby.tscn）」へワープ！
	var has_saved_character: bool = false
	
	if has_saved_character:
		print("💾 [LAUNCH] 過去の相棒を検知！直接【セントラル・ロビー（lobby.tscn）】へ次元跳躍します。")
		get_tree().change_scene_to_file(LOBBY_SCENE)
	else:
		print("🐣 [LAUNCH] 初回起動パルスを検知！【魂のキャラクター選択（character_select.tscn）】へ進みます...")
		get_tree().change_scene_to_file(CHARACTER_SELECT_SCENE)
