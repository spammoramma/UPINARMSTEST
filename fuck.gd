extends CharacterBody2D

const SPEED: float = 300.0
const JUMP_VELOCITY: float = -400.0

# We'll get the gravity value in the _ready function instead of using a constant.
var gravity: float

func _ready():
	gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta: float) -> void:
	# Add the gravity if the character is not on the floor.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump if the character is on the floor and the jump button is pressed.
	if is_on_floor() and Input.is_action_just_pressed("ui_accept"):
		velocity.y = JUMP_VELOCITY

	# Get the input direction for horizontal movement.
	var direction_x: float = Input.get_axis("move_left", "move_right")
	velocity.x = direction_x * SPEED

	# Get the input direction for vertical movement (up and down).
	var direction_y: float = Input.get_axis("move_up", "move_down")
	# Only allow vertical movement if the character is not on the floor (e.g., swimming or flying).
	if not is_on_floor():
		velocity.y += direction_y * SPEED

	# Move the CharacterBody2D.
	move_and_slide()
