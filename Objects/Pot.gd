extends StaticBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var corruptTex = preload("res://Sprites/Plant1_C.png")
onready var sprite = $Sprite

var connected = false
var potPointID = null

func connect_pot(var id: int):
	potPointID = id
	sprite.texture = corruptTex

func update_pot(var id: int):
	connect_pot(id)
