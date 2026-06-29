extends Node3D
# 📜 scripts/core/main.gd
# 🌌 [LAYER VILLAGE ROYALE] 描写中枢・ツリー順序強制捕捉トリガー v1.6 (GUIカメラ完全依存・極限軽量版)

@onready var game_manager: Node = $GameManager
@onready var tile_manager: Marker3D = $Tile

func _ready() -> void:
	print("🌌 [MAIN] 描写中枢シーンが正常にロードされました。")
	_initialize_world.call_deferred()

func _initialize_world() -> void:
	if game_manager and tile_manager:
		print("🔗 [MAIN] インフラノードの強制捕捉に成功。")
		
		var signal_bus = get_node_or_null("/root/SignalBus")
		if signal_bus:
			signal_bus.set_meta("game_manager", game_manager)
		
		print("⏳ 世界線を1フレーム進めて床の物質化を開始します...")
		await get_tree().process_frame
		
		# 仕様書v1.2（16セクターランダムマップ）の床生成ロジックの呼び出し
		var map_gen = game_manager.get("map_generator")
		if map_gen and "sectors" in map_gen:
			print("🗺️ [MAIN] セクターパケットの回収に成功。スチームパンク風ミクロステージの床を物質化します！")
			if tile_manager.has_method("visualize_tiles"):
				tile_manager.visualize_tiles(map_gen.sectors)
				print("🏁 [MAIN] 床の物質化完了。カメラはGUIの絶対座標に依存します（Q.E.D.）。")
