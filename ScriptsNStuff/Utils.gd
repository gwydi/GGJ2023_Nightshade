extends Node

var max_hp = 6
var current_hp = max_hp

onready var player = null
onready var hud = null

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
	_update_hp(1)

func connect_player(var Player):
	if player == null:
		player = Player
		player.connect("player_died_soft", self, "reset_player")
		playerStartPosition = player.startLocation
	else:
		nextPlayer = Player

func connect_hud(var hud):
	self.hud = hud
	_update_hp(0)

func _update_hp(var reduction: int):
	if current_hp - reduction <= 0:
		#todo game over
		pass
	else:
		current_hp -= reduction
		hud.updateHp(max_hp, current_hp)
