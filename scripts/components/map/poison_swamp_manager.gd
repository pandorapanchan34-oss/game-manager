extends Node
class_name PoisonSwampManager

# 🌌 [LAYER VILLAGE ROYALE] 悪魔の囁き完全執行パルス v7.0 (ワンショット確定形態)

class SwampEnums:
	enum OilPhase { NORMAL, OIL_SLICK, IGNITION, CHAIN_EXPLOSION }

@onready var tile_manager: Node3D = $"/root/main/Tile"

# 📦 各ラウンドの破滅マス
var round_target_sectors: Array = []

# 🔒 各イベントが「1回だけ実行されたか」を記録する絶対防壁フラグ
var triggered_events: Dictionary = {
	"whisper_1": false, "whisper_2": false, "whisper_3": false,
	"oil_1": false,     "oil_2": false,     "oil_3": false
}

## 📡 GameManagerから毎フレーム届く経過秒数パルス
func _on_game_timer_pulsed(elapsed_seconds: float) -> void:
	
	# ⏳ 【悪魔の囁きタイムライン】（独立したifで並列監視、すり抜け絶対不可）
	if elapsed_seconds >= 150.0 and not triggered_events["whisper_1"]: # 2分30秒
		triggered_events["whisper_1"] = true
		_execute_asymmetric_whisper(1)
		
	if elapsed_seconds >= 330.0 and not triggered_events["whisper_2"]: # 5分30秒
		triggered_events["whisper_2"] = true
		_execute_asymmetric_whisper(2)
		
	if elapsed_seconds >= 510.0 and not triggered_events["whisper_3"]: # 8分30秒
		triggered_events["whisper_3"] = true
		_execute_asymmetric_whisper(3)

	# 🛢️ 【オイル・炎・持続爆発の物理執行タイムライン】
	if elapsed_seconds >= 180.0 and not triggered_events["oil_1"]: # 3分00秒
		triggered_events["oil_1"] = true
		_apply_round_destruction(SwampEnums.OilPhase.OIL_SLICK)
		
	if elapsed_seconds >= 360.0 and not triggered_events["oil_2"]: # 6分00秒
		triggered_events["oil_2"] = true
		_apply_round_destruction(SwampEnums.OilPhase.IGNITION)
		
	if elapsed_seconds >= 540.0 and not triggered_events["oil_3"]: # 9分00秒
		triggered_events["oil_3"] = true
		_apply_round_destruction(SwampEnums.OilPhase.CHAIN_EXPLOSION)
				
## 🎰 破滅マスの選定 ＆ 囁きDB ＆ MessageManager の三位一体・情報攪乱
func _execute_asymmetric_whisper(round_num: int) -> void:
	print("\n🛰️ [AS_WARNING] 第 ", round_num, " 波・情報攪乱パケットの配分を開始します...")
	
	# 🎰 16マスのうちランダムに4マスを選定（各ラウンド固有の破滅ID）
	round_target_sectors = [round_num * 3, round_num * 3 + 1, round_num * 3 + 2, round_num * 3 + 3]
	
	# 🗺️ ルール①：最初の1マスは全員共通の「全体公開チャット」へ MessageManager 経由でアナウンス！
	var map_sector = round_target_sectors[0]
	var global_msg = "【警告】セクター %d にオイル流入の初期パルスを検知。全機回避せよ。" % map_sector
	
	var msg_man = get_node_or_null("/root/MessageManager")
	if msg_man and msg_man.has_method("send_global_chat"):
		msg_man.send_global_chat("機神アナウンス", global_msg)
	
	# 👥 ルール②：残りの3マスについて、WhisperDatabaseから嘘・真実を拾って3人に個別に隠密送出！
	var player_ids = ["peer_alpha", "peer_beta", "peer_gamma"]
	
	for i in range(3):
		var target_sector_id = round_target_sectors[i + 1]
		var player_id = player_ids[i]
		
		# 😈 1. WhisperDatabase からパケットを一本釣り！
		var whisper_packet = WhisperDatabase.get_random_packet()
		
		# 🧠 2. 嘘か真実かで送出するセクターIDの因果を捻じ曲げる
		var sector_to_send = target_sector_id
		if not whisper_packet["truth"]:
			# 嘘パケットなら無関係な偽ID（+5）をでっち上げて脳をバグらせる
			sector_to_send = (target_sector_id + 5) % 16
		
		# 🤫 3. 実在する MessageManager の暗号帯域へパス！
		if msg_man and msg_man.has_method("send_private_whisper"):
			msg_man.send_private_whisper(player_id, sector_to_send)
			
			# UI側に文章も一緒に届くよう、全体公開チャット形式で囁きをエミュレート出力
			var whisper_text = "（%s）" % whisper_packet["message"]
			msg_man.send_global_chat("悪魔の囁き ➔ %s" % player_id, whisper_text)

## 🛢️ 確定していた4マスに実際に物理破滅を執行する
func _apply_round_destruction(phase: SwampEnums.OilPhase) -> void:
	if round_target_sectors.is_empty(): return
	
	print("\n🔥 [DESTRUCTION] タイムライン確定。指定セクターへの属性執行フェーズ: ", phase)
	for sector_id in round_target_sectors:
		if tile_manager and tile_manager.has_method("contaminate_sector"):
			tile_manager.contaminate_sector(sector_id, phase)

## ⏳ 残り秒数から「分：秒」を綺麗に判定する便利関数
func min_match(remaining: float, target_min: int, target_sec: int) -> bool:
	var total_target_seconds = target_min * 60 + target_sec
	return abs(remaining - total_target_seconds) < 0.05
