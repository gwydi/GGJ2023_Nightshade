extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export(float) var pointInterval = 0.5
export(float) var ROTATION_SPEED

onready var testLine = $TestLine
onready var rootHead = $RootHead

var velocity: Vector2 = Vector2(1,0) 

var timer = 0
var points = 0

var startLocation = Vector2.ZERO
var connectedPots = []

# Called when the node enters the scene tree for the first time.
func _ready():
	print("started")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if timer <= 0:
		timer = pointInterval
		testLine.add_point(global_position)
		points += 1
	
	timer -= delta
	
	
	if Input.is_action_pressed("ui_left"):
		velocity = velocity.rotated(-ROTATION_SPEED*delta) 
	elif Input.is_action_pressed("ui_right"):
		velocity = velocity.rotated(ROTATION_SPEED * delta)
	rootHead.look_at(global_position + velocity) 
	rootHead.rotation_degrees += 90
	
	if Input.is_action_pressed("ui_accept"):
		print("Player ded")
		reset_checkpoint()
	
	#print(velocity)

func _physics_process(delta):
	global_position += velocity
	testLine.global_position -= velocity

func reset_checkpoint():
	#Reset player position to last pot or starting point
	if connectedPots.size() >= 1:
		print("died and have pots")
		var lastConnectedPot = connectedPots[connectedPots.size() -1]
		
		global_position = lastConnectedPot.global_position
		create_deadbranch(testLine.points, testLine.points[lastConnectedPot.potPointID])
		
		#Removing "dead points" from line2d
		while testLine.points.size() > lastConnectedPot.potPointID:
			testLine.points.remove(testLine.points.size() -1)
	else:
		print("died and have NO pots")
		global_position = startLocation
		create_deadbranch(testLine.points, testLine.points[1])
		
		#Removing "dead points" from line2d
		while testLine.points.size() > 1:
			testLine.points.remove(testLine.points.size() -1)
	
	print("done with reseting player")
	

func _on_DetectionArea_body_entered(body):
	if body.is_in_group("RootNode"):
		if not connectedPots.has(body):
			body.connect_pot(testLine.points.size())
			connectedPots.append(body)
			print("Connected Root to Pot with ID: " + str(testLine.points.size()))
		else:
			body.update_pot(testLine.points.size())

func create_deadbranch(var Points, var rootPoint: Vector2):
	#Creating dead branch 
	print("deletung until Point" + str(rootPoint))
	#Delete all points from start until pot point, so dead branch can branch out from pot and be recreated with proper "root"
	while Points[0] != rootPoint:
		print("Removing Point " + str(Points[0]))
		Points.remove(0)
	print("Finished removing points: " + str(Points.size()))
	
	var newDeadBranch = Line2D.new()
	newDeadBranch.points = Points
	newDeadBranch.texture = preload("res://icon.png")
	newDeadBranch.texture_mode = Line2D.LINE_TEXTURE_TILE
	
	add_child(newDeadBranch)
	
