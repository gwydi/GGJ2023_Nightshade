extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var player = $Player

onready var playerScene = preload("res://Test_R/Player.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	player.connect("player_died_soft", self, "reset_player")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _input(event):
	
	if Input.is_action_pressed("ui_accept"):
		reset_player()

func reset_player():
	print("Player ded")
	player.disconnect("player_died_soft", self, "reset_player")
	var newPlayer = playerScene.instance()
	add_child(newPlayer)
	player.reset_checkpoint(newPlayer)
	player = newPlayer
	player.connect("player_died_soft", self, "reset_player")
