extends Node
# 📜 scripts/utils/signal_bus.gd
# 🌌 [LAYER VILLAGE ROYALE] SignalBus v1.2 (Godot 4.x 最新文法適応版 / Q.E.D.)

# ☣️ マップ・崩壊関連のシグナルパケット
signal mud_warning_triggered(sector_indices: Array)   # 10秒前の予告
signal mud_execution_triggered(sector_indices: Array) # 独沼の執行

func trigger_mud_warning(sector_indices: Array) -> void:
	mud_warning_triggered.emit(sector_indices) # 🌟 Godot 4.x スタイルへ調律

func trigger_mud_execution(sector_indices: Array) -> void:
	mud_execution_triggered.emit(sector_indices)

# 👁️ 情報戦・欺瞞関連のシグナルパケット
signal private_whisper_received(peer_id: String, sector_idx: int) # 悪魔の囁き
func trigger_private_whisper(peer_id: String, sector_idx: int) -> void:
	private_whisper_received.emit(peer_id, sector_idx)

signal truth_revealed_triggered(registry_data: Dictionary) # 10分後の真実開示
func trigger_truth_revealed(registry_data: Dictionary) -> void:
	truth_revealed_triggered.emit(registry_data)

# ⚔️ 戦闘・プレイヤー関連のシグナルパケット
signal player_damaged(player_id: String, current_hp: float, damage: float)
signal player_died(player_id: String)

func trigger_player_damaged(player_id: String, current_hp: float, damage: float) -> void:
	player_damaged.emit(player_id, current_hp, damage)

func trigger_player_died(player_id: String) -> void:
	player_died.emit(player_id)

func _ready() -> void:
	print("🛰️ [SIGNAL_BUS] 宇宙の共通シグナル帯域が正常に固定されました。")