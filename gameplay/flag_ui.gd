extends AnimatedSprite2D

@export var beacon: Beacon

func _process(_delta: float) -> void:
	if animation == "default" and beacon.health <= 0:
		play("broke")
		Globals.breach()
