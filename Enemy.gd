extends Sprite

var targetPosition: Vector2
var walking = false
signal targetReached

var route
var direction
var steps
var step_counter = 0
var speed = 1

func _ready():
	pass


func _process(delta):
	if (!walking):
		return
	step_counter += speed
	position = position + direction * speed
	if (step_counter >= steps):
		walking = false
		emit_signal("targetReached")

func setTarget(target: Vector2):
	targetPosition = target

	route = targetPosition - position
	direction = route.normalized()
	rotation = direction.angle() - 0.5 * PI
	step_counter = 0
	
	steps = route.length()
	walking = true
