extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export(float) var pointInterval = 0.5
export(float) var ROTATION_SPEED

onready var testLine = $TestLine
onready var rootHead = $RootHead
onready var rootAnkPun = $RootHead/RootAnkuppelPunkt
onready var winRect = $WinRect
onready var progBar = $ProgressBar
onready var detectionArea = $DetectionArea
onready var detectionAreaGen = $DetectionAreaGen

var velocity: Vector2 = Vector2(0.5,0) 

var timer = 0
var points = 0

var startLocation = Vector2(0,0)
var connectedPots = []

var active = true
var moving = true
var water = 2000

var chargeTimer = 0
var chargeMAXThreshhold = 3
var speedModifier = 1

signal player_died_soft

# Called when the node enters the scene tree for the first time.
func _ready():
	print("started")
	Utils.connect_player(self)
	velocity = Vector2(randf() -0.5, randf() - 0.5).normalized()

	testLine.points.empty()
	testLine.global_position -= global_position

	progBar.max_value = water
	progBar.value = water


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if active:
		if timer <= 0:
			timer = pointInterval
			testLine.add_point(rootAnkPun.global_position)
			_calculateCollision()
			points += 1
		
		if water <= 0:
			emit_signal("player_died_soft")

		timer -= delta
		
		if Input.is_action_pressed("ui_down"):
			chargeTimer += delta * 10
			moving = false
		else:
			moving = true
			chargeTimer = clamp(chargeTimer - delta * 7,0,2000)
		
		if Input.is_action_pressed("ui_left"):
			velocity = velocity.rotated(-ROTATION_SPEED*delta) 
		elif Input.is_action_pressed("ui_right"):
			velocity = velocity.rotated(ROTATION_SPEED * delta)
		rootHead.look_at(global_position + velocity * 100) 

func _physics_process(delta):
	if active and moving:
		speedModifier = Utils.Floor.getTileSpeedMod(position)
		#print(speedModifier)
		#print("speedmod" + str(speedModifier))
		global_position += velocity * (chargeTimer + 1) * speedModifier
		testLine.global_position -= velocity * (chargeTimer + 1) * speedModifier
		
		if chargeTimer > 0:
			water -= velocity.length() * (chargeTimer + 1)
		else:
			water -= velocity.length()

		progBar.value = water
		#print("Water level: " + str(water))

	elif active and not moving:
		if Input.is_action_pressed("ui_down"):
			water -= velocity.length() * (chargeTimer + 1)

		progBar.value = water

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

