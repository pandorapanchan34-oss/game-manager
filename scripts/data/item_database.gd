extends Node
class_name ItemDatabase
# 📜 scripts/data/item_database.gd
# 🌌 [LAYER VILLAGE ROYALE] ItemDatabase v1.0 (最小実体化パケット)

var items: Dictionary = {}

func _ready() -> void:
	_initialize_database()
	print("🧪 [DATABASE] アイテムデータベースの帯域を確保しました。")

func _initialize_database() -> void:
	items = {
		"POTION": { "name": "回復薬", "heal_amount": 20.0 }
	}

func get_item_data(item_id: String) -> Dictionary:
	if items.has(item_id):
		return items[item_id]
	return {}