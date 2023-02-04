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

func add_Deadbranch(var Points):
	var newDeadBranch = Line2D.new()
	newDeadBranch.points = Points
	newDeadBranch.texture = deadBranchTex
	newDeadBranch.texture_mode = Line2D.LINE_TEXTURE_TILE
	
	add_child(newDeadBranch)
	newDeadBranch.set_owner(self)
