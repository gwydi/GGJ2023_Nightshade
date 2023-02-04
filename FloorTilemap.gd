extends TileMap

var tilemapScale = 0.25

func _ready():
	scale = scale * tilemapScale

func getModifier(playerPosition: Vector2):
	var mapPosition = world_to_map(playerPosition * 4)
	#print (playerPosition)
	#print (mapPosition)
	var tileIndex = get_cell(mapPosition.x, mapPosition.y)
	#print(tileIndex)
	if (tileIndex < 0):
		return 1
	return get_parent().speedMods[tileIndex]
	
