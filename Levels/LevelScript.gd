extends Node2D

export(int, 0, 20) var hp = 5
export(String) var nextLevel = null

func _ready():
	Utils.set_hp(hp)
	Utils.set_next_level(nextLevel)

