extends CanvasLayer

func _ready():
	pass 

func _input(event):
	if (Input.is_action_just_pressed("ui_accept")):
		get_tree().change_scene("res://Levels/Level1.tscn")
