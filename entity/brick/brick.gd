extends RigidBody3D
class_name Brick

@onready var brick_drop: AudioStreamPlayer3D = $BrickDrop

func _on_lifetime_timeout() -> void:
	queue_free()


func _on_body_entered(body: Node) -> void:
	brick_drop.play()
	if body is RopeClimber:
		body.kill()
