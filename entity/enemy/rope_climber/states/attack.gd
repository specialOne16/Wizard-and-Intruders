extends State
class_name AttackRopeClimber

@onready var rope_climber: RopeClimber = $"../.."

func physics_update(_delta: float) -> void:
	var player = PlayerReference.get_instance()
	if player:
		rope_climber.velocity = rope_climber.global_position.direction_to(player.global_position)
