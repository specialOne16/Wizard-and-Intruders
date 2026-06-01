extends State
class_name AttackDoorRam

const sound = ["res://entity/enemy/ram/Gate_hit_1.wav", "res://entity/enemy/ram/Gate_hit_2.wav", "res://entity/enemy/ram/Gate_hit_3.wav"]

@onready var attack_timer: Timer = $"../../AttackTimer"
@onready var audio_stream_player_3d: AudioStreamPlayer3D = $"../../AudioStreamPlayer3D"

func enter(_previous_state_path: String, _data := {}) -> void:
	attack_timer.timeout.connect(_next_attack)
	attack_timer.start(5)

func exit() -> void:
	attack_timer.timeout.disconnect(_next_attack)

func _next_attack():
	audio_stream_player_3d.stream = load(sound[Globals.door_damage])
	audio_stream_player_3d.play()
	Globals.door_damage += 1
	PlayerReference.camera.add_trauma(float(Globals.door_damage) / 2)
