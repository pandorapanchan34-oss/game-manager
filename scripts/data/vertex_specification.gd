extends Node
# 📜 scripts/data/vertex_specification.gd
# 🌌 [LAYER VILLAGE ROYALE] 2大頂点称号・距離連動演出定義コア v1.0

# 🧠 動的バインド
var enums = null

func _ready() -> void:
	var path: String = "res://scripts/data/enums.gd"
	var script_res = load(path)
	if script_res != null: enums = script_res
	print("👑 [VERTEX_SPEC] 暴力と知性の2大頂点演出マトリクスが完全物質化されました。")

## 🖨️ 称号に応じたグリッチテキスト表記の取得（仕様書 v1.1 準拠）
func get_glitch_title_text(tier_type: int) -> String:
	if not enums: return ""
	match tier_type:
		enums.GlitchTier.TIER1: return "‡灰燼の‡調律者" # 軽度汚染
		enums.GlitchTier.TIER2: return "灰燼𝔬𝔣𝔱𝔥𝔢𝔗𝔲𝔫𝔢𝔯" # 烙印者
		enums.GlitchTier.TIER3_VIOLENCE: return "𝖀𝖓𝖐𝖓𝖔𝖜𝖓_𝕭𝖊𝖆𝖘𝖙" # 第1級特異点
		enums.GlitchTier.TIER3_INTELLECT: return "∅ノ極̷点̷" # 零ノ極点
	return ""

## 🔴 1. 第1級特異点（暴力）の距離連動グリッチ音響計算（仕様書 v0.70 / v1.1 準拠）
## 距離が近いほど、環境音やBGMが激しくバグ・グリッチ化する
func calculate_singularity_glitch(distance: float) -> Dictionary:
	var effect_packet := {
		"shader_intensity": 0.0, # 画面ノイズ量
		"bgm_pitch_randomness": 0.0, # BGMのピッチの歪み
		"particle_amount": 0 # 赤黒パーティクル生成量
	}
	
	if distance < 0.0: return effect_packet
	
	# 🌟 仕様書：近いほど激しくグリッチ、遠いと微か（有効半径 100M と想定）
	if distance <= 100.0:
		var factor: float = 1.0 - (distance / 100.0) # 1.0(至近距離) 〜 0.0(100M)
		effect_packet["shader_intensity"] = factor * 0.8
		effect_packet["bgm_pitch_randomness"] = factor * 0.4
		effect_packet["particle_amount"] = int(factor * 50)
		
	return effect_packet

## 🔵 2. 零ノ極点（知性）の距離連動「静寂と鐘」のフェーズ解析（仕様書 v1.1 準拠）
## 暴君とは真逆。距離が近づくほど「無音」になり、不規則な鐘の音が精神を破壊する
func evaluate_void_field_phase(distance: float) -> Dictionary:
	var audio_packet := {
		"bgm_volume_db": 0.0,     # BGMの減衰量（0.0が通常）
		"play_execution_bell": false, # 処刑の鐘トリガー
		"footstep_only": false,    # 足音のみ化フラグ
		"is_too_late": false       # もう遅い（接触直前）
	}
	
	if distance < 0.0: return audio_packet
	
	# 🌟 ① 画面外・遠距離（150M〜250M）：完全無音・静寂のみ
	if distance > 150.0 and distance <= 250.0:
		audio_packet["bgm_volume_db"] = -80.0 # 完全消音
		
	# 🌟 ② 同マス付近・中距離（50M〜150M）：不規則な処刑の鐘の音
	elif distance > 50.0 and distance <= 150.0:
		audio_packet["bgm_volume_db"] = -15.0 # BGMが徐々に小さくなる
		audio_packet["play_execution_bell"] = true # 🔔 鐘の音を単発・不規則に鳴らす前兆トリガー
		
	# 🌟 ③ 同マス内・近距離（5M〜50M）：BGM完全消滅、足音だけが確実に響く
	elif distance > 5.0 and distance <= 5.0:
		audio_packet["bgm_volume_db"] = -80.0 # BGM完全消滅
		audio_packet["footstep_only"] = true  # 👣 足音のみ
		
	# 🌟 ④ 接触直前（5M以内）：無音 ＋ 足音すら停止（暗殺の完了）
	elif distance <= 5.0:
		audio_packet["bgm_volume_db"] = -80.0
		audio_packet["footstep_only"] = false # 足音すら停止
		audio_packet["is_too_late"] = true   # 「もう遅い」
		
	return audio_packet