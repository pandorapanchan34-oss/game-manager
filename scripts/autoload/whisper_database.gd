extends Node
# 📜 scripts/data/whisper_database.gd
# 😈 [LAYER VILLAGE ROYALE] 悪魔の囁き・情報人狼パケットデータベース v1.0

var packets: Array[Dictionary] = [
	{
		"truth": true,
		"message": "回復の泉が崩落します"
	},
	{
		"truth": false,
		"message": "戦士村が安全地帯になります"
	},
	# 💡 仕様書 v1.2 に合わせて、ぱんちゃんが欺瞞パケットを2つ追加しておきました！
	{
		"truth": false,
		"message": "癒しの神殿が次の崩落で危険地帯化します（大嘘）"
	},
	{
		"truth": true,
		"message": "騎士村周辺はまだ安全なタイムラインが維持されています"
	}
]

func get_random_packet() -> Dictionary:
	# マスターのピッキングロジックを採用。Godot 4 の pick_random() で一本釣り！
	return packets.pick_random()
