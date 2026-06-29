extends Marker3D
class_name TileManager
# 📜 scripts/map/tile_manager.gd
# 🌌 [LAYER VILLAGE ROYALE] 超軽量・空間物質化エンジンスプライト形態 v1.70

@export var texture_warrior_village: Texture2D
@export var texture_knight_village: Texture2D
@export var texture_barrier_village: Texture2D
@export var texture_mage_village: Texture2D
@export var texture_archer_village: Texture2D
@export var texture_shrine: Texture2D
@export var texture_wasteland: Texture2D
@export var texture_forest: Texture2D
@export var texture_mountain: Texture2D
@export var texture_event_island: Texture2D

const MICRO_GRID_SIZE: int = 5
const MICRO_TILE_SIZE: float = 50.0

func _ready() -> void:
	print("👁️ [TILE_MAN] 空間物質化エンジン、主従同期スタンバイ完了。")

## 🖼️ 16セクターのデータを受け取り、超軽量Sprite3Dで高速物質化
func visualize_tiles(sectors_data: Array) -> void:
	if not is_inside_tree():
		await ready
		
	for child in get_children():
		child.queue_free()
		
	for sector in sectors_data:
		for gx in range(MICRO_GRID_SIZE):
			for gy in range(MICRO_GRID_SIZE):
				
				# ─── 🧭 配置フィルター ───
				var is_stage_center = (gx == 2 and gy == 2)
				var is_village_edge = (gx % 2 == 0 and gy % 2 == 0)
				
				var should_spawn = false
				if sector.sector_type == Enums.SectorType.SHRINE or sector.sector_type == Enums.SectorType.WASTELAND:
					should_spawn = is_stage_center
				else:
					should_spawn = is_stage_center or is_village_edge
					
				if not should_spawn:
					continue
				
				# ─── ⚡ 【超軽量化調律】インテルグラフィックス救済スプライト ───
				# ※ここで変数「sprite_tile」を1回だけ宣言して生み出します！
				var sprite_tile := Sprite3D.new()
				
				# 🎨 テクスチャ装填
				var target_texture: Texture2D = _get_texture_for_type(sector.sector_type)
				if target_texture:
					sprite_tile.texture = target_texture
					
					# 📐 【真のスケール調律】
					var tex_size = target_texture.get_size()
					if tex_size.x > 0:
						# Sprite3Dの「1px = 0.01m」仕様を考慮し、正確に50メートル四方へ拡大！
						var target_scale = MICRO_TILE_SIZE / (tex_size.x * sprite_tile.pixel_size)
						sprite_tile.scale = Vector3(target_scale, target_scale, 1.0)
				
				# ドット絵をクッキリさせて負荷を下げる
				sprite_tile.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST
				# 真横に寝かせる
				sprite_tile.rotation_degrees = Vector3(-90, 0, 0)
				
				# 座標同期
				var world_x = sector.pixel_position.x + (gx * MICRO_TILE_SIZE)
				var world_z = sector.pixel_position.y + (gy * MICRO_TILE_SIZE)
				sprite_tile.position = Vector3(world_x, 0.0, world_z)
				
				sprite_tile.name = "Tile_Sec%d_Stage_%d_%d" % [sector.index, gx, gy]
				add_child(sprite_tile)
				
	print("🏁 [TILE_MAN] 必要なステージ空間のみを狙い撃ちで物質化しました（Q.E.D.）。")

func _get_texture_for_type(type: int) -> Texture2D:
	match type:
		Enums.SectorType.WARRIOR_VILLAGE: return texture_warrior_village
		Enums.SectorType.KNIGHT_VILLAGE:  return texture_knight_village
		Enums.SectorType.BARRIER_VILLAGE: return texture_barrier_village
		Enums.SectorType.MAGE_VILLAGE:    return texture_mage_village
		Enums.SectorType.ARCHER_VILLAGE:  return texture_archer_village
		Enums.SectorType.SHRINE:          return texture_shrine
		Enums.SectorType.WASTELAND:       return texture_wasteland
		Enums.SectorType.FOREST:          return texture_forest
		Enums.SectorType.MOUNTAIN:        return texture_mountain
		Enums.SectorType.ISLAND:          return texture_event_island
	return texture_wasteland
