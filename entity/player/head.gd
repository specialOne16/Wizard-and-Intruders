extends Camera3D
class_name MyCamera

@export var trauma_decay := 0.7
@export var max_translation := Vector3(1.5, 1.5, 0.0)
@export var max_rotation := Vector3(20, 20, 1.0)

var trauma := 0.0
var time := 0.0
var noise := FastNoiseLite.new()

func _ready():
	PlayerReference.camera = self
	noise.seed = randi()
	noise.frequency = 15.0

func _process(delta):
	time += delta

	var shake = trauma * trauma

	position = Vector3(
		noise.get_noise_2d(time * 10, 0) * max_translation.x * shake,
		noise.get_noise_2d(time * 10, 100) * max_translation.y * shake,
		0
	)

	rotation_degrees = Vector3(
		noise.get_noise_2d(time * 10, 200) * max_rotation.x * shake,
		noise.get_noise_2d(time * 10, 300) * max_rotation.y * shake,
		noise.get_noise_2d(time * 10, 400) * max_rotation.z * shake
	)

	trauma = max(trauma - trauma_decay * delta, 0.0)

func add_trauma(amount: float):
	trauma = clamp(trauma + amount, 0.0, 1.0)
