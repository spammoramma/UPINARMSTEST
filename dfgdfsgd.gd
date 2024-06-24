extends Sprite2D

# Speed at which the sprite follows the player
var follow_speed = 200
# Deceleration factor (the higher the value, the quicker the stop)
var deceleration = 0.95
# Current speed of the sprite
var current_speed = follow_speed

# Reference to the player node (set this to the correct path to your player node)
@onready var player = get_node("path/to/CharacterBody2D")

# This function is called every frame.
func _process(delta):
	# Calculate the direction to the player
	var direction_to_player = (player.global_position - global_position).normalized()
	
	# Check if the sprite is close enough to the player to start decelerating
	if global_position.distance_to(player.global_position) < follow_speed:
		current_speed *= deceleration  # Apply deceleration
	
	# Calculate the target position with smooth interpolation
	var target_position = global_position + direction_to_player * current_speed * delta
	global_position = global_position.lerp(target_position, delta)

	# If the sprite is very close to the player, set the speed to zero to stop
	if global_position.distance_to(player.global_position) < 1.0:
		current_speed = 0
