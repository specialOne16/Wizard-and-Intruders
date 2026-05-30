extends CharacterBody3D
class_name RopeClimber

var gravity_enabled = true
var target_beacon: Beacon

func _physics_process(delta: float) -> void:
	if gravity_enabled:
		if is_on_floor(): velocity.y = 0
		else: velocity += get_gravity() * delta
	
	var horizontal_velocity = Vector2(velocity.x, -velocity.z)
	if horizontal_velocity.length_squared() > 0.1:
		rotation.y = horizontal_velocity.angle() + PI / 2
	
	move_and_slide()
