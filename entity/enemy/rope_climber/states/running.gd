extends State
class_name RunningRopeClimber

@onready var rope_climber: RopeClimber = $"../.."
@onready var wall_detector: Area3D = $"../../WallDetector"

func enter(_previous_state_path: String, _data := {}) -> void:
	wall_detector.area_entered.connect(_touches_wall)

func exit() -> void:
	wall_detector.area_exited.disconnect(_touches_wall)

func physics_update(delta: float) -> void:
	if not rope_climber.is_on_floor():
		rope_climber.velocity += rope_climber.get_gravity() * delta
	else:
		rope_climber.velocity = Vector3.FORWARD * 3

func _touches_wall(_area: Area3D):
	finished.emit("ClimbingRopeClimber")
