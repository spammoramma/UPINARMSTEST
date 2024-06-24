extends CharacterBody2D

# variables
var speed = 200

func _ready():
	# Set the collision layer and mask for this object
	# This object exists on layer 2 (bit 1)
	collision_layer = 2
	# This object does not collide with anything (mask 0)
	collision_mask = 0

func _physics_process(delta):
	# Use the built-in 'velocity' property
	if global_position.distance_to(Global.player_position) > 100:
		velocity = global_position.direction_to(Global.player_position) * speed
	else:
		velocity = Vector2.ZERO  # Stop the movement if within 100 units

	# Call 'move_and_slide' without assigning its return value
	move_and_slide()
