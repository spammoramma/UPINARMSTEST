extends CharacterBody2D

# Speed variables for different behaviors
@export var patrol_speed: int = 100
@export var chase_speed: int = 150

# Detection and attack radii
@export var detection_radius: float = 200.0
@export var attack_radius: float = 50.0

# Patrol points and patrol timing
@export var patrol_points: Array[Vector2] = []
@export var time_between_patrol_points: float = 2.0

# Internal variables for patrol state
var current_patrol_index: int = 0
var time_since_last_patrol_change: float = 0.0

# Reference to the player and AnimatedSprite2D node
var player: CharacterBody2D = null
var animated_sprite: AnimatedSprite2D

# AI state
var state: String = "patrol"

func _ready():
	# Initialize the AnimatedSprite2D
	animated_sprite = $AnimatedSprite2D

	# Set initial position if patrol points exist
	if patrol_points.size() > 0:
		position = patrol_points[0]
		
	# Find the player node in the scene tree
	find_player()

func find_player():
	player = get_tree().root.get_node("root/Player")  # Adjust the path to your player node

func _physics_process(delta):
	match state:
		"patrol":
			patrol(delta)
		"chase":
			chase_player(delta)
		"attack":
			attack_player()

	update_animation()

func patrol(delta):
	if patrol_points.size() == 0:
		return

	var target = patrol_points[current_patrol_index]
	var direction = (target - position).normalized()
	velocity = direction * patrol_speed
	move_and_slide()

	if position.distance_to(target) < 10.0:
		time_since_last_patrol_change += delta
		if time_since_last_patrol_change >= time_between_patrol_points:
			current_patrol_index = (current_patrol_index + 1) % patrol_points.size()
			time_since_last_patrol_change = 0.0

	check_for_player()

func chase_player(delta):
	if player == null:
		return

	var direction = (player.position - position).normalized()
	velocity = direction * chase_speed
	move_and_slide()

	if position.distance_to(player.position) <= attack_radius:
		state = "attack"
	elif position.distance_to(player.position) > detection_radius:
		state = "patrol"

func attack_player():
	if player == null:
		return

	if position.distance_to(player.position) > attack_radius:
		state = "chase"
		return

	# Attack logic here
	print("Attacking player")

func check_for_player():
	if player == null:
		return

	if position.distance_to(player.position) <= detection_radius:
		state = "chase"

func update_animation():
	if velocity.x < 0:
		animated_sprite.flip_h = true
	elif velocity.x > 0:
		animated_sprite.flip_h = false

	if velocity.length() > 0:
		animated_sprite.play()
	else:
		animated_sprite.stop()
