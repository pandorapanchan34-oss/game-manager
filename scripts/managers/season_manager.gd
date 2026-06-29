extends Node
class_name SeasonManager
# 📜 scripts/data/season_manager.gd
# 🌌 [LAYER VILLAGE ROYALE] シーズン統合管理システム v1.0 (42日周期・データ永続化制御)

# 🕒 シーズン定数（仕様書確定版）
const SEASON_DURATION_DAYS: int = 42

# 📊 現在の世界線ステート（本番はシステム時間やサーバーから取得）
var current_season_id: int = 1
var elapsed_days_in_season: int = 0

# 🛠️ 参照パケット
@onready var reputation_system = get_node_or_null("/root/main/GameManager/ReputationSystem") # 存在する場合

func _ready() -> void:
	print("⏱️ [SEASON_MAN] シーズン管理中枢が起動。現在のタイムライン：シーズン %d (%d / 42日経過)" % [current_season_id, elapsed_days_in_season])

## ⏳ 日数が経過した時のパルス（テストや日付変更時にコール）
func advance_day(days: int = 1) -> void:
	elapsed_days_in_season += days
	print("📅 [SEASON_MAN] 時間が %d 日進行。現在の経過日数: %d/%d" % [days, elapsed_days_in_season, SEASON_DURATION_DAYS])
	
	if elapsed_days_in_season >= SEASON_DURATION_DAYS:
		_execute_season_wrap_up()

## 🚨 42日到達：シーズン終了・リセット＆永続化シーケンスの執行（仕様書準拠）
func _execute_season_wrap_up() -> void:
	print("\n🔔 [SEASON_MAN] ━━━━ シーズン %d の終焉が検知されました。世界線を再構築します。 ━━━━" % current_season_id)
	
	# 1. 永久保存データ（保存パケット）の選別
	var _save_data = _archive_permanent_records()
	
	# 2. 4軸人格パラメータのパージ（reputation_systemへリセットを命令）
	if reputation_system and reputation_system.has_method("reset_season_parameters"):
		reputation_system.reset_season_parameters()
	else:
		print("♻️ [SEASON_MAN] ReputationSystem未検出のため、直接4軸パラメータのパージをシミュレート。")
		
	# 3. 新シーズンの開闢・新サブ職業ローテーションの準備
	current_season_id += 1
	elapsed_days_in_season = 0
	
	_load_new_season_content()
	print("🚀 [SEASON_MAN] 新しい世界線が開闢しました。ウェルカム・トゥ・シーズン %d !!!\n" % current_season_id)

## 🗃️ 永久に残るもののパッキング（仕様書準拠）
func _archive_permanent_records() -> Dictionary:
	print("📦 [SEASON_MAN] データの選別を開始。")
	
	# 仮の現在データ（本番は playerData や global_data から抽出）
	var current_titles = ["第1級特異点", "真の調律者"] 
	var favorite_alias = "キル王者（実態：守護者）"
	
	var archived_titles: Array = []
	for title in current_titles:
		# 例：「シーズン1 第1級特異点」のフォーマットで歴史に刻印
		var format_title = "シーズン%d %s" % [current_season_id, title]
		archived_titles.append(format_title)
		print("👑 [HISTORIC] 永久称号がタイムラインに刻印されました: %s" % format_title)
		
	print("✨ [HISTORIC] 二つ名『%s』が永久保持枠に登録されました。" % favorite_alias)
	
	return {
		"archived_titles": archived_titles,
		"retained_alias": favorite_alias
	}

## ⚔️ 新シーズンコンテンツのロード（仕様書準拠）
func _load_new_season_content() -> void:
	# シーズンごとのサブ職業ローテーションテーブル
	var rotation_sub_jobs = {
		2: "竜騎士",
		3: "機工士",
		4: "吟遊詩人"
	}
	var new_job = rotation_sub_jobs.get(current_season_id, "忍者")
	
	print("🎭 [NEW_SEASON] 新サブ職業『%s』がローテーションに追加されました！" % new_job)
	print("🎨 [NEW_SEASON] 新スキン・エモートパケットがサーバーに展開されました。")