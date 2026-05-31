extends Node

var current_rope_climber = 0
var brach_count = 0

const BEACON_1_ST_WARNING = preload("uid://beewmb64e1fj2")
const BEACON_2_ND_WARNING = preload("uid://dbylvyso0pia1")
const BEACON_3_RD_WARNING = preload("uid://c4ko1g0jmv5h7")

var player: AudioStreamPlayer

func _ready() -> void:
	player = AudioStreamPlayer.new()
	add_child(player)

func breach():
	brach_count += 1
	match brach_count:
		1: player.stream = BEACON_1_ST_WARNING
		2: player.stream = BEACON_2_ND_WARNING
		3: player.stream = BEACON_3_RD_WARNING
		_: return
	player.play()
