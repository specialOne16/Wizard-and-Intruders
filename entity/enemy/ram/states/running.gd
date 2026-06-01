extends State
class_name RunningRam

@onready var ram: Ram = $"../.."
@onready var door_detector: Area3D = $"../../DoorDetector"
@onready var animation_player: AnimationPlayer = $"../../Ancient Castle with misty mountain/AnimationPlayer"

func enter(_previous_state_path: String, _data := {}) -> void:
	door_detector.body_entered.connect(_touches_wall)
	
	animation_player.play("5Action")
	ram.velocity.z = -2 *3

func exit() -> void:
	door_detector.body_entered.disconnect(_touches_wall)

func _touches_wall(_area: Node3D):
	finished.emit("AttackDoorRam")
