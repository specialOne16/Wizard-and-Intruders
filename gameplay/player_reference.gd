extends Node

var instance: Player

func get_instance() -> Player:
	if is_instance_valid(instance): return instance
	else: return null
