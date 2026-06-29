extends Control
# 📜 scripts/ui/occupation_select.gd
# 🌌 [LAYER VILLAGE ROYALE] 3層選択UI制御中枢 v1.6 (構文歪み完全パージ版)

enum Step { SUB_JOB, FAKE_JOB, MAIN_JOB, COMPLETE }
var current_step: Step = Step.SUB_JOB

# 📦 パケット回収用のテンポラリバッファ（Enum値を直接記憶）
var selected_sub_job_enum: int = -1
var selected_fake_job_enum: int = -1  # 👁️ 救済：表の顔（偽装）のEnum
var selected_main_job_enum: int = -1

var card_id_to_main_job: Dictionary = {}
var card_id_to_sub_job: Dictionary = {}

@onready var step_label: Label = get_node_or_null("StepLabel") if has_node("StepLabel") else get_node_or_null("../StepLabel")
@onready var warrior_card: Button = %WarriorCard if has_node("%WarriorCard") else find_child("WarriorCard", true, false)
@onready var shield_card: Button = %ShieldCard if has_node("%ShieldCard") else find_child("ShieldCard", true, false)
@onready var bow_card: Button = %BowCard if has_node("%BowCard") else find_child("BowCard", true, false)
@onready var mage_card: Button = %MageCard if has_node("%MageCard") else find_child("MageCard", true, false)
@onready var barrier_card: Button = %BarrierCard if has_node("%BarrierCard") else find_child("BarrierCard", true, false)

func _ready() -> void:
	if not warrior_card or not step_label:
		print("❌ [ERROR] ノードツリーの同期がまだ狂っています！")
		return
		
	# 🧠 OccupationSystemからEnum定義を動的に取得し、データ駆動マップを構築
	var occ_sys = get_node_or_null("/root/OccupationSystem")
	if occ_sys:
		card_id_to_main_job = {
			"Warrior": occ_sys.MainJobID.WARRIOR,
			"Shield":  occ_sys.MainJobID.KNIGHT,
			"Mage":    occ_sys.MainJobID.MAGE,
			"Barrier": occ_sys.MainJobID.PRIEST,
			"Bow":     occ_sys.MainJobID.ARCHER,
		}
		card_id_to_sub_job = {
			"Warrior": occ_sys.SubJobID.BERSERKER,
			"Shield":  occ_sys.SubJobID.GUARDIAN,
			"Bow":     occ_sys.SubJobID.VAGABOND,
			"Mage":    occ_sys.SubJobID.PHANTOM,
			"Barrier": occ_sys.SubJobID.SAGE,
		}
	
	# 🔗 シグナル自動結線
	warrior_card.pressed.connect(func(): _on_card_selected("Warrior"))
	shield_card.pressed.connect(func(): _on_card_selected("Shield"))
	bow_card.pressed.connect(func(): _on_card_selected("Bow"))
	mage_card.pressed.connect(func(): _on_card_selected("Mage"))
	barrier_card.pressed.connect(func(): _on_card_selected("Barrier"))
	
	_update_ui_display()

## ⚡ カードが選択された時の因果律処理
func _on_card_selected(job_id: String) -> void:
	match current_step:
		Step.SUB_JOB:
			selected_sub_job_enum = card_id_to_sub_job.get(job_id, -1)
			print("⚙️ [CHOICE] Step1確定 ➔ サブ職業(公開): ", job_id)
			current_step = Step.FAKE_JOB
			
		Step.FAKE_JOB:
			# 👁️ 救済：マスターデータ(MainJobID)から「自称・表の顔」のEnum値をパケットに記録！
			selected_fake_job_enum = card_id_to_main_job.get(job_id, -1)
			print("⚙️ [CHOICE] Step2確定 ➔ 表の顔(自己申告): ", job_id)
			current_step = Step.MAIN_JOB
			
		Step.MAIN_JOB:
			selected_main_job_enum = card_id_to_main_job.get(job_id, -1)
			print("⚙️ [CHOICE] Step3確定 ➔ メイン職業(非公開): ", job_id)
			current_step = Step.COMPLETE
			_dispatch_to_system()
			
	_update_ui_display()

func _update_ui_display() -> void:
	match current_step:
		Step.SUB_JOB:
			step_label.text = "Step 1: サブ職業（全世界へ完全公開）を選択せよ"
			step_label.modulate = Color(0.4, 0.8, 1.0)
		Step.FAKE_JOB:
			step_label.text = "Step 2: 表の顔（周囲への自己申告）を偽装せよ"
			step_label.modulate = Color(1.0, 0.8, 0.4)
		Step.MAIN_JOB:
			step_label.text = "Step 3: メイン職業（漆黒の本性・非公開）を秘匿せよ"
			step_label.modulate = Color(1.0, 0.4, 0.4)
		Step.COMPLETE:
			step_label.text = "アイデンティティ同期完了。ロビー（Hub）へ遷移します..."
			step_label.modulate = Color(0.4, 1.0, 0.4)

## 📡 3層すべてのデータ（本性・偽装・サブ）を OccupationSystem へ射出！
func _dispatch_to_system() -> void:
	var occ_sys = get_node_or_null("/root/OccupationSystem")
	if occ_sys:
		if selected_main_job_enum == -1 or selected_sub_job_enum == -1 or selected_fake_job_enum == -1:
			print("🚨 [ERROR] 3層の選択データに欠損があります。")
			return
			
		# 🛠️ 3つの選択したEnum（本性・偽装・サブ）をシステムへ引き渡す
		occ_sys.register_player_v2("local_player", "パンドラ・マスター", selected_main_job_enum, selected_sub_job_enum, selected_fake_job_enum)
			
		print("🛰️ [NETWORK] 3層職業パケットを OccupationSystem にダイレクト完全同期（Q.E.D.）")
	
	# ⏳ 調律完了。ロビーをスキップし、本戦（main.tscn）へダイレクト空間遷移！
	var main_scene_path: String = "res://scenes/main.tscn"
	
	if ResourceLoader.exists(main_scene_path):
		get_tree().change_scene_to_file(main_scene_path)
		print("🚀 [LAUNCH] 3層パケットを保持したまま、本戦戦域（main.tscn）へ突入します。")
	else:
		print("🚨 [WARN] main.tscn が見つかりません。パスを確認してください。現在の指定: ", main_scene_path)
