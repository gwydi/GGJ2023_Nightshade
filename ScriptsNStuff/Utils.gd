extends Node


onready var player = null
var playerStartPosition = Vector2.ZERO

var Floor = null
var nextPlayer = null

onready var playerScene = preload("res://Player/Player.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _input(event):
	pass

func reset_player():
	print("Player ded")
	player.z_index -= 1
	player.disconnect("player_died_soft", self, "reset_player")
	var newPlayer = playerScene.instance()
	newPlayer.startLocation = playerStartPosition
	add_child(newPlayer)
	player.reset_checkpoint(newPlayer)
	player = nextPlayer
	player.connect("player_died_soft", self, "reset_player")

func connect_player(var Player):
	if player == null:
		player = Player
		player.connect("player_died_soft", self, "reset_player")
		playerStartPosition = player.startLocation
	else:
		nextPlayer = Player
