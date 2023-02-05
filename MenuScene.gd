extends CanvasLayer

export(String) var nextScene

func _ready():
	pass 

func _input(event):
	if (Input.is_action_just_pressed("ui_accept")):
		get_tree().change_scene(nextScene)
		Utils.scene_changed()

