extends State
class_name RunningRopeClimber

@onready var rope_climber: RopeClimber = $"../.."
@onready var rope_detector: Area3D = $"../../RopeDetector"
@onready var animation_player: AnimationPlayer = $"../../RopeClimber/AnimationPlayer2"

func enter(_previous_state_path: String, _data := {}) -> void:
	rope_detector.area_entered.connect(_touches_wall)
	
	animation_player.play("Rope_Runner/Armature|mixamo_com|Layer0")
	rope_climber.velocity.z = -3

func exit() -> void:
	rope_detector.area_entered.disconnect(_touches_wall)

func _touches_wall(_area: Area3D):
	finished.emit("ClimbingRopeClimber")
