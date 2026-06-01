extends AnimatedSprite2D

@export var number = 3

func _process(_delta: float) -> void:
	if Globals.door_damage >= number:
		play("broke")
