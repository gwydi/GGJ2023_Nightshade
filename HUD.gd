extends CanvasLayer

const hpEmpty = preload("res://HpEmpty.tscn")
const hpFull = preload("res://HpFull.tscn")

func _ready():
	_updateHp()

func _process(delta):
	var playerWater = Utils.player.water
	var playerMaxWater = Utils.player.maxWater
	if playerWater != null:
		$Control/TextureProgress.value = playerWater / playerMaxWater * 1000

func _updateHp():
	var maxHp = 10
	var currentHp = 4
	var deadHp = maxHp - currentHp
	
	var offset = 0.03
	var currentOffset = 0
	
	for i in range(currentHp):
		var instance = hpFull.instance()
		instance.anchor_left = currentOffset
		instance.anchor_right += currentOffset
		$Control.add_child(instance)
		currentOffset += offset

	for i in range(deadHp):
		var instance = hpEmpty.instance()
		instance.anchor_left = currentOffset
		instance.anchor_right += currentOffset
		$Control.add_child(instance)
		currentOffset += offset
