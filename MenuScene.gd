extends CanvasLayer

export(String) var nextScene

func _ready():
	if get_node("Player") != null:
		get_node("Player").maxWater = 999999999 
		get_node("Player").water = 999999999 

func _input(event):
	if (Input.is_action_just_pressed("ui_accept")):
		get_tree().change_scene(nextScene)
		Utils.scene_changed()

