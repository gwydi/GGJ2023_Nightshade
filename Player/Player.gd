extends Node2D

enum playerStates{
	DEACTIVATED, MOVING, HOLDING, CHARGING
}
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export(float) var pointInterval = 0.5
export(float) var ROTATION_SPEED

onready var testLine = $AliveRoot
onready var deadRoot = $DeadRoot
onready var rootHead = $RootHead
onready var deadHead = $DeadHead
onready var rootAnkPun = $RootHead/RootAnkuppelPunkt
onready var winRect = $WinRect
onready var detectionArea = $DetectionArea
onready var detectionAreaGen = $DetectionAreaGen

var velocity: Vector2 = Vector2(0.5,0) 

var timer = 0
var points = 0

var startLocation = Vector2(0,0)
var connectedPots = []

var maxWater = 500
var water = maxWater

var chargeTimer = 0
var chargeMAXThreshhold = 3
var speedModifier = 1

var STATE = playerStates.MOVING

signal player_died_soft

# Called when the node enters the scene tree for the first time.
func _ready():
	print("started")
	Utils.connect_player(self)
	velocity = Vector2(randf() -0.5, randf() - 0.5).normalized()
	
	testLine.points.empty()
	testLine.global_position -= global_position
	deadRoot.global_position -= global_position



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if STATE != playerStates.DEACTIVATED:
		if timer <= 0:
			timer = pointInterval
			testLine.add_point(rootAnkPun.global_position)
			deadRoot.add_point(rootAnkPun.global_position)
			_calculateCollision()
			points += 1
		
		timer -= delta
		
		if Input.is_action_pressed("charge_boost") and STATE != playerStates.CHARGING:
			chargeTimer += delta
			STATE = playerStates.HOLDING
			if chargeTimer >= chargeMAXThreshhold:
				STATE = playerStates.CHARGING
			print("Player holding charge")
			print(chargeTimer)
		else:
			chargeTimer = clamp(chargeTimer - delta * 2,0,2000)
			if chargeTimer > 0:
				STATE = playerStates.CHARGING
				print("Player Charging")
			else:
				STATE = playerStates.MOVING
		
		if Input.is_action_pressed("steer_left"):
			velocity = velocity.rotated(-ROTATION_SPEED*delta) 
		elif Input.is_action_pressed("steer_right"):
			velocity = velocity.rotated(ROTATION_SPEED * delta)
		rootHead.look_at(global_position + velocity * 100) 
		deadHead.look_at(global_position + velocity * 100) 


func _physics_process(delta):
	if STATE == playerStates.MOVING or STATE == playerStates.CHARGING:
		speedModifier = Utils.Floor.getTileSpeedMod(position)
		#print(speedModifier)
		#print("speedmod" + str(speedModifier))
		global_position += velocity * (chargeTimer * 3 + 1) * speedModifier
		testLine.global_position -= velocity * (chargeTimer * 3 + 1) * speedModifier
		deadRoot.global_position -= velocity * (chargeTimer * 3 + 1) * speedModifier
		
		if chargeTimer > 0:
			update_water(water - velocity.length() * (chargeTimer + 1))
		else:
			update_water(water - velocity.length())
		#print("Water level: " + str(water))
		
	elif STATE == playerStates.HOLDING:
		if Input.is_action_pressed("charge_boost"):
			update_water(water - velocity.length() * (chargeTimer + 1))

func update_water(var newValue):
	water = newValue
	#print(water)
	var waterpercent : float = water / maxWater 
	rootHead.modulate = Color(1,1,1, waterpercent)
	testLine.modulate = Color(1,1,1, clamp(waterpercent,0,1))
	deadHead.modulate = Color(1,1,1, -waterpercent + 1)
	deadRoot.modulate = Color(1,1,1, clamp(-waterpercent + 1,0,1))
	#print(str(testLine.modulate.a) + " ::: " + str(deadRoot.modulate.a) + " ::: " + str(water))
	
	if water <= 0:
		emit_signal("player_died_soft")

func reset_checkpoint(var playerInstance):
	var newPlayer = playerInstance
	STATE = playerStates.DEACTIVATED
	print("Player Deactivated")
	
	#Reset player position to last pot or starting point
	if connectedPots.size() >= 1:
		print("died and have pots")
		var lastConnectedPot = connectedPots[connectedPots.size() -1]
		newPlayer.position = lastConnectedPot.global_position
		newPlayer.testLine.global_position -= lastConnectedPot.global_position
		newPlayer.deadRoot.global_position -= lastConnectedPot.global_position
	else:
		print("died and have NO pots")
		newPlayer.position = startLocation
		newPlayer.testLine.global_position -= startLocation
		newPlayer.deadRoot.global_position -= startLocation
	
	print("done with reseting player")

func _on_DetectionArea_body_entered(body):
	if body.is_in_group("RootNode"):
		update_water(maxWater)
		if not connectedPots.has(body):
			body.connect_pot(testLine.points.size())
			connectedPots.append(body)
			print("Connected Root to Pot with ID: " + str(testLine.points.size()))
		else:
			body.update_pot(testLine.points.size())
	
	if body.is_in_group("Wall"):
		emit_signal("player_died_soft")

func _on_DetectionArea_area_entered(area):
	if area.is_in_group("Manhole"):
		winRect.visible = true

func _calculateCollision():
	var line_poly = Geometry.offset_polyline_2d(testLine.points, 10)
	detectionAreaGen.position = to_local(Vector2.ZERO)
	
	# remove old colliders
	for oldCol in detectionAreaGen.get_children():
		detectionAreaGen.remove_child(oldCol)
	
	# add new colliders
	for poly in line_poly:
		var col = CollisionPolygon2D.new()
		col.set_build_mode(1)
		col.polygon = poly
		detectionAreaGen.add_child(col)
