extends CharacterBody2D

@export var float_amplitude: float = 10.0  # The maximum distance the character will float up and down
@export var float_speed: float = 2.0  # The speed at which the character will float up and down
@export var chase_speed: float = 50.0  # The speed at which the character will chase the player
@export var detection_radius: float = 10.0  # The radius within which the character will detect and chase the player

var original_y: float  # To store the original Y position of the character
var time_passed: float = 0.0  # To keep track of the time passed
var player: CharacterBody2D = null  # Reference to the player character

func _ready():
	# Store the original Y position of the character
	original_y = position.y
	# Find the player node (adjust the path to your player node)
	player = get_node_or_null("/root/Player")

func _process(delta):
	if player and position.distance_to(player.position) <= detection_radius:
		# Chase the player
		chase_player(delta)
	else:
		# Float up and down
		float_up_and_down(delta)

func float_up_and_down(delta):
	# Increase the time passed by delta
	time_passed += delta * float_speed

	# Calculate the new Y position using a sine wave
	var new_y = original_y + sin(time_passed) * float_amplitude

	# Update the character's position
	position.y = new_y

func chase_player(delta):
	# Calculate the direction to the player
	var direction = (player.position - position).normalized()
	# Move towards the player
	velocity = direction * chase_speed
	move_and_slide()
