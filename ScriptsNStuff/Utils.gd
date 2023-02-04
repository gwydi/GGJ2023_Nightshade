extends Node


onready var player = null

var Floor = null
var nextPlayer = null

onready var playerScene = preload("res://Player/Player.tscn")

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
	player = nextPlayer
	player.connect("player_died_soft", self, "reset_player")

func connect_player(var Player):
	if player == null:
		player = Player
<<<<<<< HEAD
=======
		player.connect("player_died_soft", self, "reset_player")
>>>>>>> 8ad56436a4d21b84ee7839fd314a4b29d750637a
	else:
		nextPlayer = Player
