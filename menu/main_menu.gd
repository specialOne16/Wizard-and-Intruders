extends Control

@onready var rope_attaching: AudioStreamPlayer = $RopeAttaching

func _on_play_button_pressed() -> void:
	rope_attaching.play()
	get_tree().change_scene_to_file("res://gameplay/gameplay.tscn")
