extends CharacterBody2D

# Define properties for the wandering behavior
@export var wander_area: Rect2 = Rect2(Vector2(0, 0), Vector2(400, 400))
@export var speed: float = 100.0
@export var idle_time_min: float = 1.0
@export var idle_time_max: float = 3.0

var target_position: Vector2
var idle_timer: float = 0.0
var is_idle: bool = false

func _ready():
	# Set the initial target position
	_set_new_target()

func _process(delta):
	if is_idle:
		# If idle, count down the idle timer
		idle_timer -= delta
		if idle_timer <= 0:
			is_idle = false
			_set_new_target()
	else:
		# Move towards the target position
		var direction = (target_position - global_position).normalized()
		var velocity = direction * speed * delta
		move_and_slide()

		# Check if the enemy has reached the target position
		if global_position.distance_to(target_position) < 5.0:
			is_idle = true
			idle_timer = randf_range(idle_time_min, idle_time_max)

func _set_new_target():
	# Set a new random target position within the wander area
	var x = randf_range(wander_area.position.x, wander_area.position.x + wander_area.size.x)
	var y = randf_range(wander_area.position.y, wander_area.position.y + wander_area.size.y)
	target_position = Vector2(x, y)
