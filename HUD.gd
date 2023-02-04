extends CanvasLayer

func _ready():
	pass 

func _process(delta):
	var playerWater = Utils.player.water
	if playerWater != null:
		$Control/TextureProgress.value = playerWater
	
