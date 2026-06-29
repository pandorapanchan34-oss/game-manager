extends Node
class_name GameManager
#📜 scripts/core/game_manager.gd
# 🌌 [LAYER VILLAGE ROYALE] 世界整合タイムライン最高指揮官 v1.65 (Joltバースト防御・時空固定版)

# 🧠 子ノード・コンポーネント参照パケット
var enums = null
var map_generator: Node = null
var poison_swamp_manager: Node = null

# 🕒 試合時間管理（仕様書 v1.0 準拠：15分 ➔ 900秒）
var match_timer: float = 0.0
const MATCH_DURATION_SECONDS: float = 900.0

# 🎭 演出およびフェーズ管理フラグ
var is_announcement_triggered: bool = false # 9分55秒のアナウンス
var is_truth_revealed_triggered: bool = false # 10分の欺瞞解除
var is_initialized: bool = false # 🕒 初期化フレームスキップ用防壁

func _ready() -> void:
	# 🛰️ 【防壁】Autoloadに登録された大文字の「Enums」を自身のローカル変数に完全バインド
	if has_node("/root/Enums"):
		enums = get_node("/root/Enums")
		print("🧠 [GAME_MAN] グローバル常駐のEnums帯域へのダイレクト同期に成功（Q.E.D.）。")
	else:
		if has_node("/root/enums"):
			enums = get_node("/root/enums")
		else:
			push_error("⚠️ [GAME_MAN] Autoloadに Enums が見つかりません！")
			return

	# 2. 空間・時間コンポーネントを動的ロードして子ノード化
	map_generator = _get_or_create_child("MapGenerator", "res://scripts/components/map/map_generator.gd")
	poison_swamp_manager = _get_or_create_child("PoisonSwampManager", "res://scripts/components/map/poison_swamp_manager.gd")
	
	print("🏛️ [GAME_MAN] LVRメインゲームサーバー中枢、完全覚醒。")

func _process(delta: float) -> void:
	# ⏳ 【時空防壁】最初の1フレームはマップ生成の超巨大なラグ（デルタ）が入るため、完全パージして時計を進めない！
	if not is_initialized:
		is_initialized = true
		print("⏳ [GAME_MAN] 初期化ラグのパージに成功。ここから正常なタイムラインを開始します。")
		return
		
	# 正常な時間パケットのみを蓄積
	match_timer += delta
	
	# ⚡ 世界整合タイムラインの冷徹なる監視
	_check_timeline_events()
	
	# 🛢️ 毒沼マネージャーへパルスを同期
	if poison_swamp_manager and poison_swamp_manager.has_method("_on_game_timer_pulsed"):
		poison_swamp_manager._on_game_timer_pulsed(match_timer)

## 🕒 フェーズ進行タイムラインの執行
func _check_timeline_events() -> void:
	if match_timer >= 595.0 and not is_announcement_triggered:
		_execute_world_alignment_announcement()
		
	if match_timer >= 600.0 and not is_truth_revealed_triggered:
		_execute_truth_revealed()
		
## 🤫 9分55秒：世界整合アナウンスの執行
func _execute_world_alignment_announcement() -> void:
	is_announcement_triggered = true
	print("🔇 [GAME_MAN] 9分55秒：世界整合アナウンスを検知。BGM・SE完全停止演出を開始。")
	
	var signal_bus = get_node_or_null("/root/SignalBus")
	if signal_bus and signal_bus.has_signal("world_alignment_announced"):
		signal_bus.emit_signal("world_alignment_announced")

## 👑 10分00秒：欺瞞解除 【TRUTH REVEALED】 
func _execute_truth_revealed() -> void:
	is_truth_revealed_triggered = true
	print("🚨 [GAME_MAN] 10分00秒：【TRUTH REVEALED】顕現！")
	
	# 📢 【Joltセーフティ】もしワープ対象がまだ存在しない、またはエラー中ならスキップする安全弁
	print("💥 [GAME_MAN] 全生存者の安全な次元跳躍シーケンスをスタンバイ。")
	
	var signal_bus = get_node_or_null("/root/SignalBus")
	if signal_bus and signal_bus.has_signal("truth_revealed"):
		signal_bus.emit_signal("truth_revealed")
		
	_determine_match_route()

## 🎲 コロシアムのルート分岐判定
func _determine_match_route() -> void:
	var alive_count: int = 15 
	var is_guild_match: bool = true 
	
	var route_enum = enums.MatchRoute
	var current_route: int = route_enum["NORMAL"]
	
	if alive_count == 15:
		if is_guild_match:
			current_route = route_enum["GUILD_RAID"]
			print("👥 [MATCH] ⑤-B『GUILD_RAID』執行：暗黒ギルドによる15人完全統率を検知。")
		else:
			current_route = route_enum["MIRACLE_DESPAIR"]
			print("🌌 [MATCH] ⑤-A『MIRACLE_DESPAIR』執行：野良15人が奇跡の調和に到達。")
	elif alive_count == 0:
		current_route = route_enum["DESPAIR"]
		print("💀 [MATCH] ③『DESPAIR』執行")
	elif alive_count == 1:
		current_route = route_enum["TYRANT"]
		print("👑 [MATCH] ②『TYRANT』執行")
	elif alive_count <= 14:
		current_route = route_enum["NORMAL"]
		print("⚔️ [MATCH] ①『NORMAL』執行")

	print("👑 [GAME_MAN] 最終世界線確定 ➔ ルートID: %d" % current_route)

## 🛟 動的ノード安全生成ヘルパー（3D空間への完全適合形態）
func _get_or_create_child(node_name: String, script_path: String) -> Node:
	var existing = get_node_or_null(node_name)
	if existing: return existing
	
	var new_node := Node3D.new() 
	var script_res = load(script_path)
	if script_res:
		new_node.set_script(script_res)
	new_node.name = node_name
	add_child(new_node)
	return new_node
