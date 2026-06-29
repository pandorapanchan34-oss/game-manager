extends RefCounted
class_name SectorData
# 📜 scripts/map/sector_data.gd
# 🌌 [LAYER VILLAGE ROYALE] SectorData v0.99 (Q.E.D.)

var world_center_3d: Vector2 = Vector2.ZERO

# 📊 1セクターのパケット情報
var index: int = -1
var sector_type: int = -1 # MapGeneratorNode.SectorType の int キャストを受け皿にする
var is_mud: bool = false         # 🚨 独沼（MUD）化しているか
var is_warning: bool = false     # ⏳ 次に独沼化する警告パケットが届いているか

# 🗺️ 空間配置メタデータ
var grid_x: int = 0
var grid_y: int = 0
var pixel_position: Vector2 = Vector2.ZERO

## 🧠 空間座標とインデックスの自己整合初期化
func initialize(idx: int, type_id: int, start_offset: Vector2, tile_size: float, tile_gap: float) -> void:
	index = idx
	sector_type = type_id
	
	# 【整数除算の仕様に完全準拠】
	grid_x = index % 4
	grid_y = int(index / 4.0)
	
	# 物理的な画面座標（ピクセル）を自己完結で精密計算
	pixel_position.x = start_offset.x + (grid_x * (tile_size + tile_gap))
	pixel_position.y = start_offset.y + (grid_y * (tile_size + tile_gap))

## 🎯 指定されたピクセル座標がこのセクターの帯域内に収まっているか判定（足元判定の高速化用）
func contains_position(target_pos: Vector2, tile_size: float) -> bool:
	# 隙間（TILE_GAP）を含まない、純粋なタイルの物理判定範囲
	return (target_pos.x >= pixel_position.x and target_pos.x < pixel_position.x + tile_size and
			target_pos.y >= pixel_position.y and target_pos.y < pixel_position.y + tile_size)
