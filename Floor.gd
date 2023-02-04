extends StaticBody2D
export(Dictionary) var speedMods = {
	0: 3,
	1: 3,
	3: 3,
	4: 3,
	5: 3,
	6: 3,
	7: 3,
	8: 3,
	9: 3,
	10: 1,
}

onready var tilemap = $TileMap

func _ready():
	pass


func getSpeedModifier(worldPosition :Vector2):
	if (tilemap != null):
		return tilemap.getModifier(worldPosition)
	return 1