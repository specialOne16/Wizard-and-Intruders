extends State
class_name IdleRopeClimber

@onready var animation_player_2: AnimationPlayer = $"../../RopeClimber/AnimationPlayer2"

func enter(_previous_state_path: String, _data := {}) -> void:
	animation_player_2.stop()
