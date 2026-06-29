extends Node
class_name UIManager
# 📜 scripts/ui/ui_manager.gd
# 🌌 [LAYER VILLAGE ROYALE] UIManager v1.0 (Q.E.D.)

# 👁️ インスペクターから実際のUIノードのパスを手繰り寄せる
@export var hud_path: NodePath
@export var chat_system_path: NodePath
@export var truth_revealed_ui_path: NodePath

@onready var hud: Node = get_node_or_null(hud_path)
@onready var chat_system: Node = get_node_or_null(chat_system_path)
@onready var truth_revealed_ui: Node = get_node_or_null(truth_revealed_ui_path)
@onready var SignalBus: Node = get_node_or_null("/root/SignalBus")

func _ready() -> void:
	print("🖥️ [UI_MANAGER] UI統括レイヤー起動。フロントエンドの受信待機に入ります。")
	_connect_signals()

## 🔗 シグナルバスからのイベントをUI表示へブリッジ結合
func _connect_signals() -> void:
	# 共通帯域のシグナルを購読し、UI側を動かすフックを設定
	if SignalBus:
		SignalBus.truth_revealed_triggered.connect(_on_truth_revealed)
		SignalBus.mud_warning_triggered.connect(_on_mud_warning)

func _on_truth_revealed(registry_data: Dictionary) -> void:
	print("🖥️ [UI_LOG] 真実開示シグナルを受信。UI表示を執行します。")
	if truth_revealed_ui and truth_revealed_ui.has_method("play_reveal_animation"):
		truth_revealed_ui.play_reveal_animation(registry_data)

func _on_mud_warning(sector_indices: Array) -> void:
	# 崩壊警告が鳴った際、HUDのミニマップ等に点滅パルスを送る
	if hud and hud.has_method("flash_minimap_sectors"):
		hud.flash_minimap_sectors(sector_indices)
