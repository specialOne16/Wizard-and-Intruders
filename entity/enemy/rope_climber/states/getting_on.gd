extends State
class_name GettingOnRopClimber

@onready var rope_climber: RopeClimber = $"../.."
@onready var wall_detector: Area3D = $"../../WallDetector"
@onready var animation_player: AnimationPlayer = $"../../RopeClimber/AnimationPlayer2"
@onready var above_wall_detector: RayCast3D = $"../../AboveWallDetector"

func enter(_previous_state_path: String, _data := {}) -> void:
	animation_player.play("Rope_Runner/Armature|mixamo_com|Layer0")
	rope_climber.velocity.z = -3

func exit() -> void:
	rope_climber.gravity_enabled = true

func physics_update(_delta: float) -> void:
	if rope_climber.is_on_floor():
		finished.emit("AttackRopeClimber")
