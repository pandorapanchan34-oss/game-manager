extends Node
# 📜 scripts/utils/debug_time_warper.gd
# 🌌 [LAYER VILLAGE ROYALE] 時間軸強制加速・タイムワープデバッガー v1.0

# 🧠 動的バインド
var game_manager: Node = null
var occupation_system: Node = null

func _ready() -> void:
	# 常駐スタックから最高指揮官と職業脳を回収
	game_manager = get_node_or_null("/root/GameManager")
	
	# AutoloadまたはGameManagerからOccupationSystemをバインド
	var root = get_tree().root
	if root.has_node("OccupationSystem"):
		occupation_system = root.get_node("OccupationSystem")
	
	print("⏳ [DEBUG_WARPER] タイムワープインフラ開通。")
	print(" ➔ 【1キー】: 2分55秒へジャンプ（第1回 毒沼化直前）")
	print(" ➔ 【2キー】: 9分50秒へジャンプ（世界整合アナウンス5秒前）")
	print(" ➔ 【Mキー】: ダミープレイヤー15人の『欺瞞・予想登録』を自動執行")

func _unhandled_input(event: InputEvent) -> void:
	if not event is InputEventKey: return
	var key_event = event as InputEventKey
	if not key_event.pressed or key_event.echo: return
	
	## 🎰 1. 【Mキー】で15人分のダミーデータを生成し、互いに「勝手に予想」を仕込ませる（シミュレーション準備）
	if key_event.keycode == KEY_M:
		_simulate_mock_registry_and_predictions()

	if not game_manager: 
		game_manager = get_node_or_null("/root/GameManager")
		if not game_manager: return

	## ⏳ 2. 【1キー】で最初の毒沼化フェーズ（3分 ➔ 175秒）へスキップ
	if key_event.keycode == KEY_1:
		game_manager.set("match_timer", 175.0)
		print("⚡ [WARPER] 時空が歪む……！ 試合時間を 【2分55秒（毒沼展開直前）】 へ強制同期しました。")

	## ⏳ 3. 【2キー】で最大の見せ場（9分55秒のアナウンス ➔ 10分TRUTH REVEALED）直前へスキップ
	if key_event.keycode == KEY_2:
		game_manager.set("match_timer", 590.0)
		print("⚡ [WARPER] 時空が歪む……！ 試合時間を 【9分50秒（世界整合アナウンス5秒前）】 へ強制同期しました。")

## 🧪 内部シミュレーション：15人の仮面と予想パケットを自動注入
func _simulate_mock_registry_and_predictions() -> void:
	var occ_sys = occupation_system if occupation_system else get_node_or_null("/root/OccupationSystem")
	if not occ_sys:
		print("❌ [WARPER] OccupationSystem が見つかりません。自動注入をスキップします。")
		return
		
	print("\n🧪 [WARPER] 15人宇宙のダミーデータ生成および相互推理のパケット注入を開始...")
	
	# 15人のダミー名前リスト
	var dummy_names = ["鈴木", "田中", "佐藤", "渡辺", "伊藤", "山本", "中村", "小林", "加藤", "吉田", "山田", "佐々木", "山口", "斉藤", "松本"]
	
	# 🌟 1. 全員のプレイヤー登録を執行 (メインとサブをランダムに隠匿アサイン)
	for i in range(15):
		var p_id: String = "peer_%d" % i
		var p_name: String = dummy_names[i]
		
		# 💡【堅牢化】ハードコードされた数値を避け、Enumのサイズから動的に算出
		var main_job_count = occ_sys.MainJobID.keys().size()
		var sub_job_count = occ_sys.SubJobID.keys().size()
		
		var main_job: int = i % main_job_count # WARRIOR 〜 ARCHER を均等に分配
		var fake_job: int = (main_job + 1 + randi() % (main_job_count - 1)) % main_job_count # 自分以外の職に偽装
		var sub_job: int = randi() % sub_job_count # サブ職業をランダムにアサイン
		
		occ_sys.register_player_v2(p_id, p_name, main_job, sub_job, fake_job)
	
	# 🌟 2. 全員が「勝手に隣の奴の裏職業を予想する」パケットを強制注入
	for i in range(15):
		var my_id = "peer_%d" % i
		var target_id_1 = "peer_%d" % ((i + 1) % 15)
		
		# 💡【堅牢化】"call"を避け、直接関数を呼び出すことでタイプセーフに
		occ_sys.record_prediction(my_id, target_id_1, randi() % occ_sys.MainJobID.keys().size())
		
	print("✅ [WARPER] 15人の欺瞞マトリクスの仕込みが完了しました。いつでも【2】キーを押して審判の時を迎えてください。\n")