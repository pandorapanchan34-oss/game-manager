extends Entity
class_name MachineNpc

# 🌌 [LAYER VILLAGE ROYALE] 常駐型・機神兵NPC v3.0 (マスター確定シンプルドロップ仕様)

func _ready() -> void:
	super._ready()
	# 🛠️ マスターの調律：プレイスキルアップ練習用に「硬め（高HP）」「攻撃低め」
	max_hp = 300.0       # 通常プレイヤーの3倍の耐久値
	current_hp = 300.0
	base_speed = 2.0     # コンボを叩き込みやすい低速移動
	print("🤖 [NPC] 機神兵が大地に常駐物質化しました。HP: %d (調律：硬め・練習用)" % max_hp)

## 💀 撃破時（Entityの_on_deathをオーバーライド）
func _on_death() -> void:
	print("💥 [NPC] 機神兵が大破しました。")
	
	# 🪙 生死を問わず、撃破されたら「錆びた歯車」パケットを中央銀行（EconomyManager）へ安全にプラス！
	var economy = get_node_or_null("/root/EconomyManager")
	if economy and economy.has_method("add_rusted_gear_from_npc"):
		economy.add_rusted_gear_from_npc()
	else:
		# 保険用ログパルス（グローバルシングルトンがまだ未結線の場合）
		print("⚙️ [NPC:DROP] 『錆びた歯車』を1個ドロップしました。")
		
	# 宇宙のメモリから肉体をパージ（消滅）
	queue_free()
