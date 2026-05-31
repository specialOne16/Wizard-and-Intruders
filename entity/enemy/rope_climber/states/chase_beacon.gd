extends State
class_name ChaseBeaconRopeClimber

@onready var rope_climber: RopeClimber = $"../.."
@onready var beacon_detector: Area3D = $"../../BeaconDetector"
@onready var animation_player: AnimationPlayer = $"../../RopeClimber/AnimationPlayer2"

var deg = deg_to_rad(randf_range(-30, 30))

func enter(_previous_state_path: String, _data := {}) -> void:
	animation_player.play("Rope_Runner/Armature|mixamo_com|Layer0")
	beacon_detector.area_entered.connect(_reach_beacon)
	
	if deg == 0: deg = -1

func exit() -> void:
	rope_climber.velocity = Vector3.ZERO
	beacon_detector.area_entered.disconnect(_reach_beacon)

func physics_update(_delta: float) -> void:
	if rope_climber.target_beacon:
		var horizontal_velocity = rope_climber.global_position.direction_to(rope_climber.target_beacon.global_position) * 2
		rope_climber.velocity = Vector3(
			horizontal_velocity.x, rope_climber.velocity.y, horizontal_velocity.z
		).rotated(Vector3.UP, deg)

func _reach_beacon(_area: Area3D):
	finished.emit("AttackBeaconRopeClimber")
