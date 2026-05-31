extends RigidBody3D
class_name Brick


func _on_lifetime_timeout() -> void:
	queue_free()


func _on_body_entered(body: Node) -> void:
	if body is RopeClimber:
		body.queue_free()
