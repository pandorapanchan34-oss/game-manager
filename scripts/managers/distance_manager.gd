extends Node
# 📜 scripts/combat/distance_manager.gd
# 🌌 [LAYER VILLAGE ROYALE] DistanceManager v1.1 (3D空間・プレイヤー間距離解析コア)

## 🔍 2つの実体（Entity）の間の3D直線距離を抽出
func get_distance_between(entity_a: Node3D, entity_b: Node3D) -> float:
	if not is_instance_valid(entity_a) or not is_instance_valid(entity_b):
		return -1.0
	return entity_a.global_position.distance_to(entity_b.global_position)

## 📡 囁き電波到達チェック（例：距離50メートル以内なら囁きチャット可能など）
func is_within_whisper_range(entity_a: Node3D, entity_b: Node3D, max_range: float = 50.0) -> bool:
	var dist = get_distance_between(entity_a, entity_b)
	if dist < 0.0: return false
	return dist <= max_range

## ⚔️ 接近遭遇エンティティのリストアップ（AIの思考予測パケット用）
func get_nearby_entities(center_entity: Node3D, all_entities: Array, radius: float) -> Array:
	var targets := []
	for entity in all_entities:
		if entity == center_entity: continue
		if is_instance_valid(entity) and entity is Node3D:
			if center_entity.global_position.distance_to(entity.global_position) <= radius:
				targets.append(entity)
	return targets