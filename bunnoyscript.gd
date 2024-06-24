extends CharacterBody2D

# Speed at which the character follows the mouse
@export var follow_speed: int = 200
# Variable to store the target position
var target_position: Vector2 = Vector2.ZERO
# Flag to check if the mouse is being dragged
var is_dragging: bool = false

# Reference to the AnimatedSprite2D node
var animated_sprite: AnimatedSprite2D

func _ready():
	# Set the process input to true so we can detect mouse events
	set_process_input(true)
	# Initialize the AnimatedSprite2D
	animated_sprite = $AnimatedSprite2D

func _input(event):
	# Check for mouse button events
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			# When the left mouse button is pressed or released, update dragging state
			is_dragging = event.pressed
			# Update the target position when the mouse is pressed
			if is_dragging:
				target_position = get_global_mouse_position()

func _physics_process(delta):
	if is_dragging:
		# Update the target position continuously while dragging
		target_position = get_global_mouse_position()
		# Calculate the direction to the target position
		var direction = global_position.direction_to(target_position)
		# Set the velocity towards the target position
		velocity = direction * follow_speed
		# Check the direction and flip the sprite if moving left
		if direction.x < 0:
			animated_sprite.flip_h = true
		elif direction.x > 0:
			animated_sprite.flip_h = false
	else:
		# If not dragging, stop the movement
		velocity = Vector2.ZERO

	# Move the character with the updated velocity
	move_and_slide()
