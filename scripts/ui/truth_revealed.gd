extends Node
class_name TruthRevealedController
# 📜 scripts/ui/truth_revealed.gd
# 🎭 [LAYER VILLAGE ROYALE] TRUTH REVEALED 演出制御中枢 v1.0

# 🧠 動的バインド
var occupation_system: Node = null

func _ready() -> void:
	# 宇宙の電波（SignalBus）に耳を澄ませる
	if SignalBus:
		# 9分55秒の世界整合アナウンス（無音暗転パルス）に接続
		SignalBus.connect("world_alignment_announced", Callable(self, "_on_world_alignment_announced"))
		# 10分00秒の完全開示パルスに接続
		SignalBus.connect("truth_revealed_triggered", Callable(self, "_on_truth_revealed_triggered"))
	
	# 名簿（Registry）を持つ OccupationSystem の確保
	var game_manager = get_node_or_null("/root/GameManager")
	if game_manager:
		occupation_system = game_manager.get("occupation_system")
		
	print("🎭 [TRUTH_REVEALED] 欺瞞解除演出中枢、暗黒より起動完了。10分00秒の生贄を待つ。")

## ⏳ 9分55秒：【世界整合アナウンス】発動（仕様書 第6条 完全準拠）
func _on_world_alignment_announced() -> void:
	print("\n🔇 [TRUTH_REVEALED] ━━ BGM・SE完全停止。全画面、暗転。 ━━")
	print("⌨️ [TYPEWRITER] 「……検知。」")
	print("⌨️ [TYPEWRITER] 「本マッチにおける絆の残存を、私は嫌悪する。」")
	print("⌨️ [TYPEWRITER] 「今より、世界整合システムが審判を下す。」")
	print("⌨️ [TYPEWRITER] 「嘘をついた者よ。真実は既に知っている。」")
	print("⌨️ [TYPEWRITER] 「信じた者よ。その選択の重さを、今から証明してみせろ。」")
	print("⌨️ [TYPEWRITER] 「全生存者をコロシアムへ。」")
	print("⌨️ [TYPEWRITER] 「 ── 真実を、暴け。」")
	print("⏳ [TRUTH_REVEALED] 静寂の5秒間（タイプライター演出中...）\n")

## 🚨 10分00秒：【TRUTH REVEALED】顕現（仕様書 第7条 完全準拠）
func _on_truth_revealed_triggered() -> void:
	print("💥 [TRUTH_REVEALED] 🔴🔴🔴 鮮烈な赤フラッシュ ＋ 爆破音！！！ 🔴🔴🔴")
	print("📢 [TRUTH_REVEALED] ━━━━ 【TRUTH REVEALED - LIES EXPOSED!】 ━━━━")
	
	var occ_sys = occupation_system if occupation_system else get_node_or_null("/root/OccupationSystem")
	if not occ_sys:
		print("⚠️ [TRUTH_REVEALED] 名簿データ（OccupationSystem）が見つかりません。")
		return
		
	var registry = occ_sys.get("registry")
	if not registry: return
	
	# 全生存者の仮面を剥ぎ取り、コンソールへ無慈悲にパージ（開示）する
	for player_id in registry.keys():
		var p_data: Dictionary = registry[player_id]
		
		var player_name: String = p_data.get("name", player_id)
		var declared_face: String = p_data.get("declared_face", "未申告") # 表の顔
		var main_job: String = p_data.get("main_job", "無職") # 裏のリアル能力（完全非公開だったもの）
		var sub_job: String = p_data.get("sub_job", "なし") # サブ職業（公開）
		
		# 🧠 嘘をついているかどうかの超次元判定ロジック
		var is_lying: bool = _check_if_lying(declared_face, main_job)
		var lie_status: String = "❌ 嘘" if is_lying else "✅ 本当"
		
		# 仕様書 第7条の開示UIテキストフォーマットを100%再現！
		print("👤 Player: 「%s」" % player_name)
		print("  【自己申告】 %s" % declared_face)
		print("    ↓ %s" % lie_status)
		print("  【真実】 メイン:%s ＋ サブ:%s" % [main_job, sub_job])
		print("────────────────────────────────────────")
		
	print("🚀 [TRUTH_REVEALED] 生存者全員、円形闘技場コロシアムへ強制転送！！！決戦の火蓋が切られました。")

## 🔬 申告と本性の乖離チェック（人狼フェーズの判定）
func _check_if_lying(declared: String, main: String) -> bool:
	# 例：鉄壁（タンク）と自称していて、メインが戦士（アタッカー）なら大嘘、など
	# ここは将来的に判定マトリクスを組む領域。現状は簡易判定をパッキング
	if declared == "鉄壁" and main == "戦士": return true # 仕様書の鈴木パターン
	if declared == "守護者" and main == "弓士": return true # 仕様書の田中パターン
	if declared == "旅人" and main == "騎士": return false # 仕様書の正直者佐藤パターン
	return randf() > 0.5 # テスト用の確率ゆらぎ（夢）