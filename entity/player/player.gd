extends CharacterBody3D
class_name Player

@export var spawn_position: Node3D

@export_group("Movement")
@export var walk_speed := 5.0
@export var jump_velocity := 4.5
@export var dash_speed := 20.0
@export var dash_duration := 0.2

@export_group("Camera")
@export var mouse_sensitivity := 0.002
@export var tilt_upper_limit := deg_to_rad(90)
@export var tilt_lower_limit := deg_to_rad(-90)

@onready var head = $Head
@onready var object_scan: RayCast3D = $Head/ObjectScan
@onready var fall_area_detector: Area3D = $FallAreaDetector
@onready var wizard_hand: AnimatedSprite2D = $CanvasLayer/WizardHand
@onready var vfx: AnimatedSprite2D = $CanvasLayer/VFX

@onready var dash_sound: AudioStreamPlayer = $Dash

var is_dashing := false
var dash_timer := 0.0


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	PlayerReference.instance = self
	
	fall_area_detector.area_entered.connect(func(_body): _spawn())
	
	_spawn()


func _unhandled_input(event):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * mouse_sensitivity)
		head.rotate_x(-event.relative.y * mouse_sensitivity)
		head.rotation.x = clamp(head.rotation.x, tilt_lower_limit, tilt_upper_limit)
	
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		if not wizard_hand.is_playing():
			wizard_hand.play("attack")
			
			await get_tree().create_timer(0.5).timeout
			if object_scan.is_colliding():
				var collider = object_scan.get_collider()
				if collider is RopeClimber:
					Globals.current_rope_climber -= 1
					collider.queue_free()
			
			vfx.visible = true
			vfx.play("attack")
			await vfx.animation_finished
			vfx.visible = false


func _spawn():
	global_transform = spawn_position.global_transform 


func _physics_process(delta):
	if not is_on_floor():
		if velocity.y < 0: velocity += get_gravity() * 2 * delta
		else: velocity += get_gravity() * delta
	
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
	
	if Input.is_action_just_pressed("dash") and not is_dashing:
		dash_sound.play()
		is_dashing = true
		dash_timer = dash_duration
	
	if is_dashing:
		dash_timer -= delta
		if dash_timer <= 0:
			is_dashing = false

	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	var current_speed = dash_speed if is_dashing else walk_speed
	
	if direction:
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)
		velocity.z = move_toward(velocity.z, 0, current_speed)
	
	move_and_slide()
