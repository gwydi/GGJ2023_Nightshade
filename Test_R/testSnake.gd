extends KinematicBody2D


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
	
	#print(velocity)

func _physics_process(delta):
	move_and_collide(velocity)
	testLine.global_position -= velocity
