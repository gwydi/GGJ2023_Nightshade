extends TileMap

func _ready():
	pass

func getModifier(playerPosition: Vector2):
	var mapPosition = world_to_map(playerPosition * 4)
	
	#print (playerPosition)
	#print (mapPosition)
	var tileIndex = get_cell(mapPosition.x, mapPosition.y)
	#print(tileIndex)
	
	if (tileIndex < 0):
		return 1
	return get_parent().speedMods[tileIndex]
	
