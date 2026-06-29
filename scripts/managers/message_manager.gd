extends Node
# 📜 scripts/network/message_manager.gd
# 🌌 [LAYER VILLAGE ROYALE] MessageManager v1.1 (ローカル暗号秘匿通信網)

## 🤫 悪魔の囁き（個別メッセージパケット）をローカル帯域へ安全に中継
func send_private_whisper(target_peer_id: String, sector_idx: int) -> void:
	print("🤫 [MSG_MAN:🔒暗号パケット] ピア %s へ悪魔の囁きを送出中... ➔ セクター %d が崩壊する？" % [target_peer_id, sector_idx])
	
	# マスターの特製シグナルバスを通じてUIやシステムへ安全にパス
	var signal_bus = get_node_or_null("/root/SignalBus")
	if signal_bus and signal_bus.has_method("trigger_private_whisper"):
		signal_bus.trigger_private_whisper(target_peer_id, sector_idx)

## 🔊 全体チャットの送受信パケット（ローカル処理）
func send_global_chat(sender_name: String, message_text: String) -> void:
	print("💬 [MSG_MAN:🌍全体公開] %s: %s" % [sender_name, message_text])
