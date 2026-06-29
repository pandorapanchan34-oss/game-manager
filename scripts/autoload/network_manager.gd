extends Node
class_name NetworkManagerLocal
# 📜 scripts/network/network_manager.gd
# 🌌 [LAYER VILLAGE ROYALE] NetworkManager v1.1 (悪魔の囁き同期パルス版)

# 📡 接続状態フラグ
var is_connected_to_host: bool = false
var ping_ms: int = 0

func _ready() -> void:
	_establish_local_pipeline()

## 🔌 ローカルモック通信網の開通
func _establish_local_pipeline() -> void:
	is_connected_to_host = true
	ping_ms = 3  # 有限帯域の応答速度を表現
	print("🌐 [NETWORK] 有限帯域通信パイプライン開通。同期パケット応答時間: %dms" % ping_ms)

## 🥷 悪魔の囁き・暗号化パケットのネットワーク送出ブリッジ
func relay_private_whisper(peer_id: String, sector_idx: int) -> void:
	if not is_connected_to_host: 
		return
		
	# 【未来のマルチプレイ拡張の布石】
	# 本来のマルチプレイ時はここにRPCを記述して対象クライアントの関数を直接叩く
	# rpc_id(peer_id, "receive_private_whisper", sector_idx)
	
	# 現段階（ローカルモック）では通信ログとして完全に整合性を証明
	print("🛰️ [NET_RELAY] ピア %s 宛ての暗号化パケット（セクター:%d）を帯域に送出しました。" % [peer_id, sector_idx])

## 📡 汎用パケット送信の器（モック状態での警告パージ完了）
func send_packet_to_server(_action_type: String, _data: Dictionary) -> void:
	if not is_connected_to_host: 
		return
	# 将来的にサーバーへアクションとデータを送出する際にアンダースコアを外して結合
	pass
