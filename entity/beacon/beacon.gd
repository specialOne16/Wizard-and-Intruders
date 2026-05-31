extends Node3D
class_name Beacon

var broken = false
var health = 10

func attack():
	health -= 1
	if health <= 0:
		$AnimatedSprite3D.play("broke")
