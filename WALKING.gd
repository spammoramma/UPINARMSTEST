extends CharacterBody2D

# Exported variable for speed, allowing it to be adjusted in the editor
@export var speed: int = 200

# Reference to the AnimatedSprite2D node
var animated_sprite: AnimatedSprite2D

func _ready():
	# Initialize the AnimatedSprite2D
	animated_sprite = $AnimatedSprite2D

# This function will handle the input
func handle_input():
	var move_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = move_direction * speed
	
	# Flip the sprite based on the movement direction
	if move_direction.x < 0:
		animated_sprite.flip_h = true
	elif move_direction.x > 0:
		animated_sprite.flip_h = false

# The physics process function where movement is handled
func _physics_process(delta):
	handle_input()
	move_and_slide()
	
	Global.player_position = global_position
