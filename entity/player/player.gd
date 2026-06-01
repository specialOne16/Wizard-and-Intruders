extends CharacterBody3D
class_name Player

const BRICK = preload("uid://c3q7cw5ireg4q")

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
@onready var m_1_swing: AudioStreamPlayer = $M1Swing
@onready var skill_release: AudioStreamPlayer = $SkillRelease
@onready var spell_charge: AudioStreamPlayer = $SpellCharge

var is_dashing := false
var dash_timer := 0.0
var charge_duration = 0.0

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
		if event.button_index == MOUSE_BUTTON_LEFT:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			if wizard_hand.animation == "default" or wizard_hand.animation == "run":
				wizard_hand.play("attack")
				m_1_swing.play()
			
				await get_tree().create_timer(0.25).timeout
				if object_scan.is_colliding():
					var collider = object_scan.get_collider()
					if collider is RopeClimber:
						Globals.current_rope_climber -= 1
						collider.kill()
				
				vfx.visible = true
				vfx.play("attack")
				await vfx.animation_finished
				vfx.visible = false
				
				await wizard_hand.animation_finished
				wizard_hand.play("default")
		
		if event.button_index == MOUSE_BUTTON_RIGHT:
			if event.pressed and (wizard_hand.animation == "default" or wizard_hand.animation == "run"):
				wizard_hand.play("charge")
				spell_charge.play()
				charge_duration = 0
			if not event.pressed and wizard_hand.animation == "charge":
				spell_charge.stop()
				if charge_duration >= 0.85:
					skill_release.play()
					
					var brick: Brick = BRICK.instantiate()
					brick.global_transform = object_scan.global_transform
					brick.linear_velocity = object_scan.global_position.direction_to($Head/Target.global_position) * 15
					add_sibling(brick)
					
					wizard_hand.play("release")
					await wizard_hand.animation_finished
					wizard_hand.play("default")
				else:
					wizard_hand.play("default")


func _spawn():
	global_transform = spawn_position.global_transform 


func _process(delta: float) -> void:
	charge_duration += delta


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
		if wizard_hand.animation == "default": wizard_hand.play("run")
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed
	else:
		if wizard_hand.animation == "run": wizard_hand.play("default")
		velocity.x = move_toward(velocity.x, 0, current_speed)
		velocity.z = move_toward(velocity.z, 0, current_speed)
	
	move_and_slide()
