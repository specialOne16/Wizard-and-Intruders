extends Timer
class_name EnemySpawner

const ROPE_CLIMBER = preload("uid://dnclcbmlbim0x")

@onready var left_rope: Area3D = $LeftRope
@onready var right_rope: Area3D = $RightRope
@onready var center_left_rope: Area3D = $CenterLeftRope
@onready var center_right_rope: Area3D = $CenterRightRope

@onready var beacons: Array[Beacon] = [%LeftBeacon, %CenterLeftBeacon, %CenterRightBeacon, %RightBeacon]
@onready var ropes: Array[Node3D] = [$LeftRope, $CenterLeftRope, $CenterRightRope, $RightRope]

func _ready() -> void:
	timeout.connect(spawn)

func spawn():
	var beacon = beacons.pick_random()
	var index = beacons.find(beacon)
	
	if beacon.broken:
		beacons.remove_at(index)
		ropes.remove_at(index)
		return
	
	var climber: RopeClimber = ROPE_CLIMBER.instantiate()
	climber.global_transform = ropes[index].global_transform.translated(Vector3.BACK * 5)
	climber.target_beacon = beacon
	add_sibling(climber)
