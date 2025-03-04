extends GPUParticles2D

@export var random_amount_range : int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	amount += randi_range(0, random_amount_range)
	emitting = true
	connect("finished", queue_free)
