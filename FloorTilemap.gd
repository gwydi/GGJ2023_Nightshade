extends TileMap

func _ready():
	pass

func getModifier(playerPosition: Vector2):
	var mapPosition = world_to_map(playerPosition * 4)
<<<<<<< HEAD
	#print (playerPosition)
	#print (mapPosition)
	var tileIndex = get_cell(mapPosition.x, mapPosition.y)
	#print(tileIndex)
=======
	var tileIndex = get_cell(mapPosition.x, mapPosition.y)
>>>>>>> 235b1a46b9aabc58c754e6aac0a7585ef0567b0d
	if (tileIndex < 0):
		return 1
	return get_parent().speedMods[tileIndex]
	
