extends Node2D

export(int, 0, 20) var hp = 5
export(String) var nextLevel = null
export(AudioStreamMP3) var levelBG 

func _ready():
	Utils.set_hp(hp)
	Utils.set_next_level(nextLevel)
	
	if levelBG != null:
		var audioPlayer = AudioStreamPlayer2D.new()
		audioPlayer.stream = levelBG
		audioPlayer.volume_db = -4
		audioPlayer.play()
		add_child(audioPlayer)
		

