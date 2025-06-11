@tool
extends Resource
class_name boss_template_wave

@export var wave: Array[int]

func _init():
	if Engine.is_editor_hint():
		if wave == null || wave.size() == 0:
			wave.resize(8)