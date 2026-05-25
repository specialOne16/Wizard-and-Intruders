extends CharacterBody3D
class_name Player

# --- Settings ---
@export_group("Movement")
@export var walk_speed := 5.0
@export var jump_velocity := 4.5
@export var dash_speed := 20.0
@export var dash_duration := 0.2 # How long the dash lasts in seconds

@export_group("Camera")
@export var mouse_sensitivity := 0.002
@export var tilt_upper_limit := deg_to_rad(90)
@export var tilt_lower_limit := deg_to_rad(-90)

# --- Internal Variables ---
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var is_dashing := false
var dash_timer := 0.0

@onready var head = $Head # Make sure your Node3D is named 'Head'
@onready var object_scan: RayCast3D = $Head/ObjectScan

func _ready():
	# Capture the mouse so it doesn't leave the game window
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event):
	# Mouse Look logic
	if event is InputEventMouseMotion:
		# Rotate the whole player left/right (Y axis)
		rotate_y(-event.relative.x * mouse_sensitivity)
		
		# Rotate only the head up/down (X axis)
		head.rotate_x(-event.relative.y * mouse_sensitivity)
		
		# Clamp head rotation so you can't flip upside down
		head.rotation.x = clamp(head.rotation.x, tilt_lower_limit, tilt_upper_limit)
	
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		if event.button_index == MOUSE_BUTTON_LEFT:
			object_scan.force_raycast_update()
			if object_scan.is_colliding():
				var collider = object_scan.get_collider()
				if collider is Node:
					collider.queue_free()

func _physics_process(delta):
	# 1. Handle Gravity
	if not is_on_floor():
		velocity.y -= gravity * delta

	# 2. Handle Jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity

	# 3. Handle Dash Logic
	if Input.is_action_just_pressed("dash") and not is_dashing:
		is_dashing = true
		dash_timer = dash_duration

	# Dash Timer Countdown
	if is_dashing:
		dash_timer -= delta
		if dash_timer <= 0:
			is_dashing = false

	# 4. Handle Movement Input
	# Get the input direction based on the WASD keys
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	
	# Calculate movement direction relative to the player's rotation
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	# Determine current speed (Dash vs Walk)
	var current_speed = dash_speed if is_dashing else walk_speed
	
	if direction:
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed
	else:
		# Smoothly slow down if no input is given
		velocity.x = move_toward(velocity.x, 0, current_speed)
		velocity.z = move_toward(velocity.z, 0, current_speed)

	# Apply all movement
	move_and_slide()

	# 5. Enemy Detection with Raycast
	if object_scan:
		object_scan.force_raycast_update()
		if object_scan.is_colliding():
			var collider = object_scan.get_collider()
			# Check the collider and its parents for the script (e.g., if we hit a collision shape)
			var entity = collider
			while entity:
				if entity.has_method("been_hit_by_raycast"):
					# Hide all rope climbers first, then show the one we hit
					var rope_climbers = get_tree().get_nodes_in_group("rope_climbers")
					for climber in rope_climbers:
						if climber.has_method("been_hit_by_raycast"):
							climber.been_hit_by_raycast(false)
					entity.been_hit_by_raycast(true)
					break
				entity = entity.get_parent()
		else:
			# No collision - reset all rope climbers to hidden (they'll handle their own reset)
			var rope_climbers = get_tree().get_nodes_in_group("rope_climbers")
			for climber in rope_climbers:
				if climber.has_method("been_hit_by_raycast"):
					climber.been_hit_by_raycast(false)

	# Optional: Press ESC to unlock mouse
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
