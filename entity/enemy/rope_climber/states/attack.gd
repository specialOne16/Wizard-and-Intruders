extends State
class_name AttackRopeClimber

@onready var rope_climber: RopeClimber = $"../.."
@onready var animation_player: AnimationPlayer = $"../../RopeClimber/AnimationPlayer2"

func enter(_previous_state_path: String, _data := {}) -> void:
	animation_player.play("Rope_Runner/Armature|mixamo_com|Layer0")

func physics_update(_delta: float) -> void:
	if rope_climber.target_beacon:
		var horizontal_velocity = rope_climber.global_position.direction_to(rope_climber.target_beacon.global_position) * 2
		rope_climber.velocity = Vector3(horizontal_velocity.x, rope_climber.velocity.y, horizontal_velocity.z)
