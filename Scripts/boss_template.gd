extends Resource
class_name boss_template

@export var boss_name: String
@export var waves: Array[boss_template_wave]

func get_uniques() -> Array[int]:
	var unique_inputs: Array[int] = []
	for wave in waves:
		for slot in wave.wave:
			if slot == 0:
				continue
			if !unique_inputs.has(slot):
				unique_inputs.append(slot)
	unique_inputs.sort()
	return unique_inputs
	