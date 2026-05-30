extends Timer
class_name EnemySpawner

const ROPE_CLIMBER = preload("uid://dnclcbmlbim0x")

@export var spawner: Array[Node3D]

func _ready() -> void:
	timeout.connect(spawn)

func spawn():
	var spawn_position = spawner.pick_random()
	if not is_instance_valid(spawn_position):
		spawner.erase(spawn_position)
		return
	
	var climber: RopeClimber = ROPE_CLIMBER.instantiate()
	climber.global_transform = spawn_position.global_transform
	add_sibling(climber)
