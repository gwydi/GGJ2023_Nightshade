extends CanvasLayer

func _ready():
	pass 

func _process(delta):
	var playerWater = Utils.player.water
	var playerMaxWater = Utils.player.maxWater
	print ("playerwater" + str(playerWater) + "/" + str(playerMaxWater))
	if playerWater != null:
		$Control/TextureProgress.value = playerWater / playerMaxWater * 1000

