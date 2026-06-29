extends CharacterBody3D
class_name Entity
# 📜 scripts/core/entity.gd
# 🌌 [LAYER VILLAGE ROYALE] 3D肉体・数理執行ベース v2.1 (迷子パス完全パージ版)

# 📊 基礎ステータス（全員100固定・成長なし）
var max_hp: float = 100.0
var current_hp: float = 100.0

# ⚙️ 内部データパケットバインド用（PlayerDataクラスと動的同期）
var data: PlayerData = null

# 🏃 速度・環境制御パケット
var base_speed: float = 5.0 
var current_speed: float = 5.0
var is_in_mud: bool = false

# 🧠 動的ロード用変数の代わりに、大文字の「Enums」を宇宙全体で共有
var enums = null

func _ready() -> void:
	# 🛰️ 【防壁】Autoloadに登録された大文字の「Enums」を自身のローカル変数にバインド
	# これにより、既存の「enums.MainOccupation...」といったドット参照コードが一切壊れずに動きます！
	if has_node("/root/Enums"):
		enums = get_node("/root/Enums")
		print("🧠 [%s] EntityインフラへのAutoload:Enums接続に成功しました（Q.E.D.）。" % name)
	else:
		# 万が一Autoload名が小文字の「enums」だった場合のセーフティ
		if has_node("/root/enums"):
			enums = get_node("/root/enums")

func _physics_process(_delta: float) -> void:
	# ☣️ 毒沼環境デバフのリアルタイム計算
	if is_in_mud:
		current_speed = 1.5
	else:
		current_speed = base_speed
	
	move_and_slide()

## 🛡️ PlayerDataパケットを肉体にバインド
func bind_player_data(player_data: PlayerData) -> void:
	data = player_data
	data.calculate_allocated_stats()
	print("🛡️ [%s] ステータス合成完了 ➔ ATK:%d, DEF:%d, MDEF:%d" % [name, data.stats["atk"], data.stats["def"], data.stats["mdef"]])

## 💥 ダメージ適用パケット
func take_damage(amount: float) -> void:
	current_hp = max(0.0, current_hp - amount)
	print("💥 [%s] 被弾：残りHP -> %d" % [name, current_hp])
	
	if current_hp <= 0.0:
		_on_death()

## 🔮 回復魔法パケット
func receive_healing() -> void:
	var mdef: float = 0.0
	if data:
		mdef = data.stats["mdef"]
		
	var healing_amount: float = 20.0 + (mdef * 0.5)
	current_hp = min(max_hp, current_hp + healing_amount)
	print("💖 [%s] 回復執行：+%d ➔ 現在HP:%d" % [name, healing_amount, current_hp])

## 💀 パケット消滅および生命反転ロジック
func _on_death() -> void:
	if self is Player:
		print("👻 [%s] プレイヤーの肉体が臨界点を突破。ゴーストフェーズ（霊体反転）を執行します。" % name)
		if data:
			data.is_ghost = true
			
		if self.has_method("transition_to_ghost"):
			self.transition_to_ghost()
	else:
		print("💀 [%s] の肉体パケットが完全消滅しました。ロジックから除外します。" % name)
		queue_free()

func transition_to_ghost() -> void:
	pass
