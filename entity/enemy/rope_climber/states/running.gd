extends State
class_name RunningRopeClimber

@onready var rope_climber: RopeClimber = $"../.."
@onready var wall_detector: Area3D = $"../../WallDetector"
@onready var animation: AnimationPlayer = $"../../Body/Animation"

func enter(_previous_state_path: String, _data := {}) -> void:
	wall_detector.body_entered.connect(_touches_wall)
	
	animation.play("Rope_Runner/Armature|mixamo_com|Layer0")
	rope_climber.velocity.z = -3

func exit() -> void:
	wall_detector.body_entered.disconnect(_touches_wall)

func _touches_wall(_area: Node3D):
	finished.emit("ClimbingRopeClimber")
