extends Node

var max_hp = 6
var current_hp = max_hp

var nextLevel = null

onready var player = null
onready var hud = null

var playerStartPosition = Vector2.ZERO

var Floor = null
var nextPlayer = null
var camera = null

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
		get_tree().change_scene("res://DeathScene.tscn")
		scene_changed()
	else:
		current_hp -= reduction
		hud.updateHp(max_hp, current_hp)

func level_success():
	if nextLevel == null:
		get_tree().change_scene("res://VictoryScene.tscn")
	else:
		get_tree().change_scene(nextLevel)

func set_hp(var maxHp):
	self.max_hp = max_hp
	self.current_hp = max_hp
	_update_hp(0)

func scene_changed():
	if (player != null && is_instance_valid(player)):
		player.queue_free()
	player = null
	playerStartPosition = null
	
func set_next_level(var level):
	nextLevel = level
