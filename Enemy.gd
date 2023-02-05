extends Sprite

onready var stunTimer = $StunTimer
onready var stunSprite = $StunSprite
onready var ActiveSprite = $ActiveSprite
onready var soundWhistling = $WhistlingSound
onready var soundHit = $HiteSound

var targetPosition: Vector2
var walking = false
signal targetReached

var route
var direction
var steps
var step_counter = 0
var speed = 1
var stunned = false

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
	soundWhistling.play()

func _on_Area2D_area_entered(area):
	if !stunned and walking:
		var isPlayer = area.is_in_group("Player")
		print("enemy entered ")
		if (isPlayer):
			if(not area.get_parent().isCharging()):
				print("player")
				area.get_parent().emit_signal("player_died_soft")

func stun():
	stunned = true
	walking = false
	stunSprite.visible = true
	ActiveSprite.visible = false
	stunTimer.start()
	soundWhistling.stop()
	soundHit.play()

func _on_StunTimer_timeout():
	stunned = false
	walking = true
	stunSprite.visible = false
	ActiveSprite.visible = true
	soundWhistling.play()

func _on_HiteSound_finished():
	soundHit.stop()
