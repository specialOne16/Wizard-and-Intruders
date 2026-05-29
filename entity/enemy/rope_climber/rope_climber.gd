extends CharacterBody3D
class_name RopeClimber

@onready var aim_ring = $AimRing

func _ready():
	add_to_group("rope_climbers")
	# Ensure aim ring starts hidden
	if aim_ring:
		aim_ring.visible = false

func _exit_tree():
	if is_in_group("rope_climbers"):
		remove_from_group("rope_climbers")

func _physics_process(_delta: float) -> void:
	move_and_slide()

func been_hit_by_raycast(hit):
	if aim_ring:
		aim_ring.visible = hit
