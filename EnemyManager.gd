extends Node

var poolPosition = Vector2(-1000, -1000)
export(PoolVector2Array) var points
var enemyInstance 
var timer :Timer
var waitTime = 30

func _ready():
	enemyInstance = $Enemy
	timer = $Timer
	_reset_position()
	
func _reset_position():
	enemyInstance.position = poolPosition

func _spawn():
	points[0]

func _done():
	timer.wait_time = waitTime

func _on_Timer_timeout():
	_spawn()
