extends Node
# 🌟 class_name を削除（またはコメントアウト）して、型の自動登録をパージ！
# class_name ResonanceSys 

# 📜 scripts/data/resonance_sys.gd
# 🌌 [LAYER VILLAGE ROYALE] 因縁システム v1.2 (Autoload競合完全パージ版)

# 🧠 因縁マトリクスデータ構造
# { "鈴木のID": { "田中のID": 45.0 (因縁値) } }
var resonance_matrix: Dictionary = {}

# ⚔️ 復讐補正定数（仕様書22条に完全準拠）
const REVENGE_DAMAGE_BOOST: float = 1.20 # 与ダメージ +20%
const REVENGE_DAMAGE_TAKEN: float = 1.20 # 被ダメージ +20% (お互いに危険)

func _ready() -> void:
	# 宇宙の共通シグナル帯域に結線し、戦闘デバフパルスを監視開始
	if SignalBus:
		SignalBus.connect("player_damaged", Callable(self, "_on_player_damaged_detected"))
	print("⛓️ [RESONANCE] 因縁自動検知システムが正常に固定されました。復讐の波長を監視します。")

## ⚡ 裏切り（FFや攻撃行為）の自動パルス検知
func _on_player_damaged_detected(player_id: String, _current_hp: float, damage: float) -> void:
	# 本来は「誰が攻撃したか（attacker_id）」をネットワークパケットから抽出して照合する
	# ここでは仮に、同じチーム内でのフレンドリーファイア（裏切り）が発生したと仮定してシミュレート
	var mock_attacker_id = "peer_betrayer_tanaka"
	
	# 自傷行為でなければ、因縁値を蓄積
	if mock_attacker_id != player_id:
		add_resonance_point(player_id, mock_attacker_id, damage * 0.5) # ダメージ量に応じて因縁が過熱

## 📈 因縁（RESONANCE）の蓄積と世界線強制介入トリガー
func add_resonance_point(victim_id: String, attacker_id: String, amount: float) -> void:
	if not resonance_matrix.has(victim_id):
		resonance_matrix[victim_id] = {}
		
	if not resonance_matrix[victim_id].has(attacker_id):
		resonance_matrix[victim_id][attacker_id] = 0.0
		
	# 因縁カルマの加算
	resonance_matrix[victim_id][attacker_id] = clamp(resonance_matrix[victim_id][attacker_id] + amount, 0.0, 100.0)
	
	var current_res = resonance_matrix[victim_id][attacker_id]
	print("⛓️ [RESONANCE] 因縁蓄積 ➔ 被害者:%s ⇄ 加害者:%s | 因縁値: %.1f" % [victim_id, attacker_id, current_res])
	
	# 閾値突破：RESONANCE DETECTED（仕様書22条）
	if current_res >= 50.0:
		print("⚡ [RESONANCE DETECTED] 警告：因縁値が限界突破。次回以降、高確率で同レイヤー（マッチ）へ強制配置されます。")

## ⚔️ 【数理調律】戦闘システム（damage_calculator.gdなど）から呼び出される補正関数
# 被害者と加害者の因縁をチェックし、ダメージ倍率を逆算して返す
func get_revenge_multiplier(attacker_id: String, target_id: String) -> float:
	# 1. 自分が相手に復讐する場合（相手から過去に裏切られているか？）
	if resonance_matrix.has(attacker_id) and resonance_matrix[attacker_id].has(target_id):
		if resonance_matrix[attacker_id][target_id] >= 50.0:
			print("🔥 [REVENGE BURST] 復讐補正発動！ 与ダメージが 1.2 倍に跳ね上がります！")
			return REVENGE_DAMAGE_BOOST # 与ダメ+20%
			
	# 2. 相手から自分が復讐される場合（過去に自分が相手を裏切っているか？）
	if resonance_matrix.has(target_id) and resonance_matrix[target_id].has(attacker_id):
		if resonance_matrix[target_id][attacker_id] >= 50.0:
			print("💀 [REVENGE THREAT] 危険！ 過去の因縁により、被ダメージが 1.2 倍に過熱しています！")
			return REVENGE_DAMAGE_TAKEN # 被ダメ+20%
			
	return 1.0 # 補正なし