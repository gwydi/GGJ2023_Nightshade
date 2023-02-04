extends StaticBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var deadBranchTex = preload("res://icon.png")

var connected = false
var potPointID = null

func connect_pot(var id: int):
	potPointID = id

func update_pot(var id: int):
	potPointID = id
