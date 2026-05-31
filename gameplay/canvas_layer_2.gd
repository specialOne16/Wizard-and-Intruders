extends CanvasLayer

func _ready() -> void:
	visible = false

func _process(_delta: float) -> void:
	if Globals.brach_count >= 4:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_tree().paused = true
		visible = true


func _on_button_pressed() -> void:
	Globals.current_rope_climber = 0
	Globals.brach_count = 0
	get_tree().paused = false
	get_tree().reload_current_scene()
