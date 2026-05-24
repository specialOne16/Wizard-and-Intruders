extends CharacterBody3D

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

	# Optional: Press ESC to unlock mouse
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
