extends StaticBody2D
export(Dictionary) var speedMods = {
	0: 3,
	1: 3,
	2: 3,
	3: 3,
	4: 3,
	5: 3,
	6: 3,
	7: 3,
	8: 3,
	9: 3,
	10: 1,
	22: 3,
}

var speedModsAgain = {
	-1: 1,#not valid, tihi
	1: 2.5, #Dirt
	2: 1.5, #Brick
	3: 0.5, #Stone
	10: 1, #not valid, tihi
}

var tilemaps = []

func _ready():
	tilemaps.append($TileMapStone)
	tilemaps.append($TileMapBrick)
	tilemaps.append($TileMapDirt)
	Utils.Floor = self

func getTileSpeedMod(var WorldPosition: Vector2):
	var tileType = -1
	for tm in tilemaps:
		var mapPosition = tm.world_to_map(WorldPosition * 4)
		var tileIndex = tm.get_cell(mapPosition.x, mapPosition.y)
		if tileIndex != -1 and tm.z_index > tileType:
			tileType = tm.z_index
	
	return speedModsAgain[tileType]
