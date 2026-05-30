extends State
class_name ClimbingRopeClimber

@onready var rope_climber: RopeClimber = $"../.."
@onready var rope_detector: Area3D = $"../../RopeDetector"
@onready var animation_player: AnimationPlayer = $"../../RopeClimber/AnimationPlayer2"

func enter(_previous_state_path: String, _data := {}) -> void:
	animation_player.play("Rope_Climb/Armature|mixamo_com|Layer0")
	rope_climber.gravity_enabled = false
	rope_climber.velocity = Vector3.UP * 2
	
	rope_detector.area_exited.connect(_reach_top)

func exit() -> void:
	rope_climber.velocity = Vector3.ZERO
	rope_detector.area_exited.disconnect(_reach_top)

func _reach_top(_area: Area3D):
	finished.emit("GettingOnRopClimber")
