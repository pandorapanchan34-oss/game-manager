extends Node
class_name BaseJob

var player: Player

# Player本体にアクション実行を依頼するためのシグナル
@warning_ignore("unused_signal")
signal action_triggered(action_name: String, extra_data: Dictionary)

# HUD更新用のシグナル (例: チャージゲージ)
@warning_ignore("unused_signal")
signal charge_updated(charge_name: String, value: float)

# 初期化時にPlayerノードへの参照を受け取る
func initialize(owner_player: Player):
	self.player = owner_player

# 各ジョブのフレームごとの処理（入力検知など）
func handle_process(_delta: float):
	pass # 各ジョブクラスでこのメソッドをオーバーライドする
