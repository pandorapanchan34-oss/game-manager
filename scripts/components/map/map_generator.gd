extends Node3D
class_name MapGenerator

# ローカル定義のセクター種別列挙（外部 enums 未使用時のフォールバック）
enum SectorType {
	WARRIOR_VILLAGE,
	KNIGHT_VILLAGE,
	BARRIER_VILLAGE,
	MAGE_VILLAGE,
	ARCHER_VILLAGE,
	SHRINE,
	WASTELAND,
	FOREST,
	MOUNTAIN,
	ISLAND
}
# 📐 空間の絶対定義
const SECTOR_SIZE: float = 250.0
const GRID_SIZE: int = 4 

# 🤖 機神兵のアセット装填
const MACHINE_NPC_SCENE: PackedScene = preload("res://scenes/play/machine_npc.tscn")

# 📊 【仕様変更】生態系定数
const MAX_MONSTERS: int = 10       # 戦場に常駐する最大数
var current_monster_count: int = 0 # 現在生存している機神兵の数

# 🌐 16セクターのデータ実体
var sectors: Array[SectorData] = []

func _ready() -> void:
	randomize()
	generate_battlefield()
	# 🛰️ 初期配置として10体を完全ランダムに物質化
	_spawn_initial_monsters()

## 🎲 16マスの完全ランダムシャッフル生成ロジック
func generate_battlefield() -> void:
	sectors.clear()
	var pool: Array[int] = [
		SectorType.WARRIOR_VILLAGE, SectorType.KNIGHT_VILLAGE,
		SectorType.BARRIER_VILLAGE, SectorType.MAGE_VILLAGE, SectorType.ARCHER_VILLAGE,
		SectorType.SHRINE, SectorType.SHRINE, SectorType.SHRINE,
		SectorType.WASTELAND, SectorType.WASTELAND, SectorType.WASTELAND,
		SectorType.FOREST, SectorType.FOREST, SectorType.FOREST,
		SectorType.MOUNTAIN, SectorType.ISLAND
	]
	pool.shuffle()
	
	var idx: int = 0
	for y in range(GRID_SIZE):
		for x in range(GRID_SIZE):
			var sector := SectorData.new()
			var world_pos := Vector2(x * SECTOR_SIZE, y * SECTOR_SIZE)
			sector.initialize(idx, idx, world_pos, pool[idx], false)
			sectors.append(sector)
			print("🗺️ [MAP_GEN] セクター %d 確定 ➔ タイプID:%d" % [idx, sector.sector_type])
			idx += 1
			# ❌ 旧ログパージ：16回連呼されていた「1キロ四方〜」をここからパージ！

	# 🏁 【新星・完全調律ログ】すべてのピースが組み合わさった瞬間に、1回だけ高らかに宣言！
	print("🏁 [MAP_GEN] 全16セクターが完全結合し、1キロ四方の大自然が物質化しました（Q.E.D.）。")

## 🤖 ① 10体の初期ランダムデプロイ
func _spawn_initial_monsters() -> void:
	var sector_indices: Array = []
	for i in range(16): sector_indices.append(i)
	sector_indices.shuffle()
	
	for i in range(MAX_MONSTERS):
		var target_sector_id = sector_indices[i]
		_spawn_at_sector(target_sector_id)

## 📡 ② セクターを指定して機神兵を召喚
func _spawn_at_sector(sector_id: int) -> void:
	if not MACHINE_NPC_SCENE or current_monster_count >= MAX_MONSTERS: return
	
	@warning_ignore("integer_division")
	var gy: int = sector_id / GRID_SIZE 
	var gx: int = int(sector_id % GRID_SIZE)
	
	var center_x: float = (gx * SECTOR_SIZE) + (SECTOR_SIZE / 2.0)
	var center_z: float = (gy * SECTOR_SIZE) + (SECTOR_SIZE / 2.0)
	var spawn_pos_3d := Vector3(center_x, 0.0, center_z)
	
	var machine_instance = MACHINE_NPC_SCENE.instantiate()
	
	# ⛓️ 死亡（ツリー退出）時のリスポーン検知結線
	machine_instance.tree_exited.connect(_on_monster_destroyed)
	
	var main_scene = get_node_or_null("/root/main")
	if main_scene:
		main_scene.call_deferred("add_child", machine_instance)
	else:
		call_deferred("add_child", machine_instance)
		
	machine_instance.set_deferred("global_position", spawn_pos_3d)
	
	current_monster_count += 1
	print("🤖 [MAP_GEN] セクター %d (安全地帯) の中心点 %s に機神兵をデプロイ（現在数: %d/10）" % [sector_id, str(spawn_pos_3d), current_monster_count])

## 💀 ③ 破壊パルス受信 ➔ 安全地帯へのリスポーン回路
func _on_monster_destroyed() -> void:
	current_monster_count = max(0, current_monster_count - 1)
	
	# 🌐 【防壁1】入る瞬間のチェック
	if not is_inside_tree() or get_tree() == null:
		return

	print("💥 [MAP_GEN] 機神兵の消失を検知。残存数: %d。リスポーンシーケンスを起動。" % current_monster_count)
	
	# 🕒 3秒のインターバル（この待機中にゲームが終了することがある）
	await get_tree().create_timer(3.0).timeout
	
	# 🪐 【防壁2：最重要】3秒待った後、復活を執行する直前に「世界線がまだ生きているか」を再確認！
	# これがないと、ゲーム終了後の無の世界で無限リスポーンの因果が爆発します。
	if not is_inside_tree() or get_tree() == null:
		print("🛑 [MAP_GEN] 待機中に世界線が閉鎖されたため、リスポーンの執行を完全パージします（Q.E.D.）。")
		return
		
	_respawn_process()

func _respawn_process() -> void:
	var safe_sectors: Array = []
	for sector in sectors:
		if not sector.is_mud:
			safe_sectors.append(sector.sector_id)
			
	if safe_sectors.size() == 0:
		print("⚠️ [MAP_GEN] 安全なセクターがこの宇宙に存在しません（全土崩壊）。リスポーンを完全停止。")
		return
		
	safe_sectors.shuffle()
	var chosen_sector_id = safe_sectors[0]
	
	_spawn_at_sector(chosen_sector_id)

# 🌟 既存の次元逆算メソッド
func get_sector_index_from_position(flat_pos_2d: Vector2) -> int:
	var gx: int = floor(flat_pos_2d.x / SECTOR_SIZE)
	var gy: int = floor(flat_pos_2d.y / SECTOR_SIZE)
	if gx < 0 or gx >= GRID_SIZE or gy < 0 or gy >= GRID_SIZE: return -1
	return gy * GRID_SIZE + gx

func is_sector_mud(idx: int) -> bool:
	if idx >= 0 and idx < sectors.size(): return sectors[idx].is_mud
	return false
