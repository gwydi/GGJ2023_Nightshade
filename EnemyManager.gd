extends Node

var poolPosition = Vector2(-1000, -1000)
var points
var enemyInstance 
var timer :Timer
export var waitTime = 10
export var initialWaitTime = 2
var currentPointIndex = 0

func _ready():
	enemyInstance = $Enemy
	timer = $Timer
	points = $Path.points
	_reset_position()
	timer.wait_time = initialWaitTime
	timer.start()
	
func _reset_position():
	enemyInstance.position = poolPosition

func _spawn():
	enemyInstance.position = points[0]
	currentPointIndex = 1
	_next()

func _done():
	_reset_position()
	timer.wait_time = waitTime
	timer.start()

func _on_Timer_timeout():
	_spawn()

func _on_Enemy_targetReached():
	_next()

func _next():
	if (len(points) > currentPointIndex):
		enemyInstance.setTarget(points[currentPointIndex])
		currentPointIndex += 1
	else:
		_done()
