extends Node


onready var player = null

var Floor = null
var nextPlayer = null

onready var playerScene = preload("res://Player/Player.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _input(event):
	pass

func reset_player():
	print("Player ded")
	player.disconnect("player_died_soft", self, "reset_player")
	var newPlayer = playerScene.instance()
	add_child(newPlayer)
	player.reset_checkpoint(newPlayer)
	player = nextPlayer
	player.connect("player_died_soft", self, "reset_player")

func connect_player(var Player):
	if player == null:
		player = Player
		player.connect("player_died_soft", self, "reset_player")
	else:
		nextPlayer = Player
