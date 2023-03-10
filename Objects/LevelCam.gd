extends Camera2D


export var decay = 0.9  # How quickly the shaking stops [0, 1].
export var max_offset = Vector2(50, 35)  # Maximum hor/ver shake in pixels.
export var max_roll = 0.1  # Maximum rotation in radians (use sparingly).
export (NodePath) var target  # Assign the node this camera will follow.
onready var noise = OpenSimplexNoise.new()

var noise_y = 0

var trauma = 0.0  # Current shake strength.
var trauma_power = 1  # Trauma exponent. Use [2, 3].

func _ready():
	randomize()
	noise.seed = randi()
	noise.period = 4
	noise.octaves = 2
	Utils.camera = self

func add_trauma(amount):
	trauma = min(trauma + amount, 1.0)

func _process(delta):
	if target:
		global_position = get_node(target).global_position
	if trauma:
		trauma = max(trauma - decay * delta, 0)
		shake()
	
	if Input.is_action_pressed("ui_page_down"):
		trauma += 0.1
		print(trauma)

func shake():
	trauma = clamp(trauma, -1, 1)
	var amount = pow(trauma, trauma_power)
	noise_y += 1
	rotation = max_roll * amount * noise.get_noise_2d(noise.seed, noise_y)
	offset.x = max_offset.x * amount * noise.get_noise_2d(noise.seed*2, noise_y)
	offset.y = max_offset.y * amount * noise.get_noise_2d(noise.seed*3, noise_y)
