extends Node

var instance: Player
var camera: MyCamera

func get_instance() -> Player:
	if is_instance_valid(instance): return instance
	else: return null
