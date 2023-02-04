extends StaticBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export(Array, Texture) var texturesNormal
export(Array, Texture) var texturesCorrupted

onready var sprite = $Sprite

var connected = false
var potPointID = null

var texRAND = 0

func _ready():
	randomize()
	texRAND = randi() % 3
	sprite.texture = texturesNormal[texRAND]

func connect_pot(var id: int):
	potPointID = id
	sprite.texture = texturesCorrupted[texRAND]

func update_pot(var id: int):
	connect_pot(id)
