@tool
extends Resource
class_name pregenerated_wave

@export var wave: Array[enemy_identifier] = []

func _init():
	if Engine.is_editor_hint():
		var identifier = preload("res://Scripts/resources/enemy_identifier.gd")
		if wave == null || wave.size() == 0:
			wave.resize(8)
			for n in 8:
				wave[n] = identifier.new()