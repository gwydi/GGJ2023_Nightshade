extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export(float) var pointInterval = 0.5
export(float) var ROTATION_SPEED
export(float) var surviveSeconds = 10

onready var testLine = $TestLine
onready var rootHead = $RootHead

var velocity: Vector2 = Vector2(1,0) 

var timer = 0
var points = 0

var startLocation = Vector2(0,0)
var connectedPots = []

var active = true
var moving = true
var surviveTimer = surviveSeconds

var preChargeVelocity = Vector2.ZERO
var chargeTimer = 0
var chargeMAXThreshhold = 3
var speedModifier = 1

signal player_died_soft

# Called when the node enters the scene tree for the first time.
func _ready():
	print("started")
	testLine.points.empty()
	testLine.global_position -= global_position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if active:
		if timer <= 0:
			timer = pointInterval
			testLine.add_point(global_position)
			points += 1
		
		if surviveTimer <= 0:
			emit_signal("player_died_soft")
		
		surviveTimer -= delta
		timer -= delta
		
		if Input.is_action_pressed("ui_down"):
			chargeTimer += delta * 5
			moving = false
			preChargeVelocity = velocity.normalized() # normalized so its always a clean direction and cant accidentaly be stacked
		else:
			moving = true
			chargeTimer = clamp(chargeTimer - delta,0,2000) 
		
		
		print(chargeTimer)
		print(velocity)
		
		if Input.is_action_pressed("ui_left"):
			velocity = velocity.rotated(-ROTATION_SPEED*delta) 
		elif Input.is_action_pressed("ui_right"):
			velocity = velocity.rotated(ROTATION_SPEED * delta)
		rootHead.look_at(global_position + velocity) 
		rootHead.rotation_degrees += 90

func _physics_process(delta):
	if active and moving:
		global_position += velocity * (chargeTimer + 1) * speedModifier
		testLine.global_position -= velocity * (chargeTimer + 1) * speedModifier
		speedModifier = get_parent().get_node("Floor").getSpeedModifier(position)
		

func reset_checkpoint(var playerInstance):
	var newPlayer = playerInstance
	active = false
	
	#Reset player position to last pot or starting point
	if connectedPots.size() >= 1:
		print("died and have pots")
		var lastConnectedPot = connectedPots[connectedPots.size() -1]
		newPlayer.position = lastConnectedPot.global_position
		newPlayer.testLine.global_position -= lastConnectedPot.global_position
	else:
		print("died and have NO pots")
		newPlayer.position = startLocation
		newPlayer.testLine.global_position -= startLocation
	
	print("done with reseting player")

func _on_DetectionArea_body_entered(body):
	if body.is_in_group("RootNode"):
		if not connectedPots.has(body):
			body.connect_pot(testLine.points.size())
			connectedPots.append(body)
			print("Connected Root to Pot with ID: " + str(testLine.points.size()))
		else:
			body.update_pot(testLine.points.size())
