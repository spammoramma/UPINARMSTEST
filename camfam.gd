extends Camera2D

# The speed at which the camera catches up to the player
@export var smooth_speed: float = 5.0
# Offset from the player's position
@export var custom_offset: Vector2 = Vector2(0, 0)
# Zoom speed factor
@export var zoom_speed: float = 0.1
# Minimum and maximum zoom levels
@export var min_zoom: float = 0.5
@export var max_zoom: float = 2.0

# Target zoom level for smooth zooming
var target_zoom: Vector2

func _ready():
	# Make sure the camera doesn't move instantly to the player's position
	position_smoothing_enabled = true
	# Set the smoothing speed
	position_smoothing_speed = smooth_speed
	# Set the camera's offset from the player
	drag_left_margin = custom_offset.x
	drag_top_margin = custom_offset.y
	drag_right_margin = custom_offset.x
	drag_bottom_margin = custom_offset.y
	# Initialize target zoom to the current zoom
	target_zoom = zoom

func _input(event):
	# Check for mouse wheel events to zoom in and out
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			zoom_in()
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			zoom_out()

func _process(delta):
	# Calculate the target position with the offset
	var target_position = get_parent().global_position + custom_offset
	# Interpolate the camera's position towards the target position
	global_position = global_position.lerp(target_position, delta * smooth_speed)
	# Smoothly interpolate the current zoom towards the target zoom
	zoom = zoom.lerp(target_zoom, delta * smooth_speed)

func zoom_in():
	# Decrease the target zoom level
	var new_zoom = target_zoom - Vector2(zoom_speed, zoom_speed)
	# Clamp the zoom level to the minimum and maximum zoom
	new_zoom.x = clamp(new_zoom.x, min_zoom, max_zoom)
	new_zoom.y = clamp(new_zoom.y, min_zoom, max_zoom)
	target_zoom = new_zoom

func zoom_out():
	# Increase the target zoom level
	var new_zoom = target_zoom + Vector2(zoom_speed, zoom_speed)
	# Clamp the zoom level to the minimum and maximum zoom
	new_zoom.x = clamp(new_zoom.x, min_zoom, max_zoom)
	new_zoom.y = clamp(new_zoom.y, min_zoom, max_zoom)
	target_zoom = new_zoom
