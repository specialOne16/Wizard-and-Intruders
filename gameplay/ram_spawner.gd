extends Timer

const RAM = preload("uid://c5xn4nkkw1on3")

@export var spawn_position: Node3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start(0)
	#start(randf_range(10, 15))

func _on_timeout() -> void:
	var ram: Ram = RAM.instantiate()
	ram.global_transform = spawn_position.global_transform
	add_sibling(ram)
	
	start(randf_range(40, 60))
