extends round_info
class_name boss_round

@export var boss_round_name: String = ""
@export var boss_round_info: Array[boss_wave] = []

func is_wave_in_round(wave_index) -> bool:
	if wave_index >= boss_round_info.size():
		return false
	else:
		return true

func get_wave(wave_number) -> Array[int]:
	var wave_to_submit: Array[int] = []
	var info:= boss_round_info[wave_number]
	wave_to_submit = info.pregen_wave.wave if info.pregenerated else wave_gen.get_wave(info.challenge_rating)
	return wave_to_submit