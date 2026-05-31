extends State
class_name AttackBeaconRopeClimber

@onready var rope_climber: RopeClimber = $"../.."
@onready var beacon_detector: Area3D = $"../../BeaconDetector"
@onready var animation_player: AnimationPlayer = $"../../RopeClimber/AnimationPlayer2"

func enter(_previous_state_path: String, _data := {}) -> void:
	animation_player.play(["Rope_AttackV1/Armature|mixamo_com|Layer0", "Rope_AttackV2/Armature|mixamo_com|Layer0"].pick_random())
	animation_player.animation_finished.connect(_next_attack)

func exit() -> void:
	animation_player.animation_finished.disconnect(_next_attack)

func update(_delta: float) -> void:
	if rope_climber.target_beacon and rope_climber.target_beacon.health <= 0:
		finished.emit("IdleRopeClimber")

func _next_attack(anim_name: StringName):
	rope_climber.target_beacon.attack()
	if anim_name.contains("Attack"):
		animation_player.play(["Rope_AttackV1/Armature|mixamo_com|Layer0", "Rope_AttackV2/Armature|mixamo_com|Layer0"].pick_random())
