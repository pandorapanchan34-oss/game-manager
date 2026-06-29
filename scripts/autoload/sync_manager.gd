extends Node
class_name SyncManager
# 📜 scripts/network/sync_manager.gd
# 🌌 [LAYER VILLAGE ROYALE] SyncManager v1.0 (Q.E.D.)

@export var network_manager_path: NodePath
@onready var network_manager: Node = get_node_or_null(network_manager_path)

# ⏳ 同期レート制御（1秒間に20回同期 = 0.05秒間隔）
const SYNC_INTERVAL: float = 0.05
var sync_timer: float = 0.0

func _ready() -> void:
	print("🔄 [SYNC_MAN] パケット同期マネージャーが正常に待機状態へ遷移しました。")

func _process(delta: float) -> void:
	if network_manager == null or not network_manager.is_connected_to_host:
		return
		
	sync_timer += delta
	if sync_timer >= SYNC_INTERVAL:
		sync_timer = 0.0
		_execute_global_synchronization()

## 🛰️ 全生存プレイヤーのパケット同期の執行
func _execute_global_synchronization() -> void:
	# ここで各プレイヤーノードの位置データなどを集約し、NetworkManager経由で同期パケットを飛ばす
	# 現段階では静かに帯域を維持
	pass