extends Resource
class_name round_info

@export_group("Basic Waves")
@export var challenge_rating: Array[int] = []
@export var card_numbers: Array[pregenerated_wave] = []

@export_group("Boss Info")
@export var has_boss: bool = false
@export var boss: Array[boss_round] = []

func is_wave_in_round(wave_index) -> bool:
	var biggest_array = challenge_rating.size() if challenge_rating.size() > card_numbers.size() else card_numbers.size()
	if wave_index >= biggest_array:
		return false
	else:
		return true

func get_wave(wave_number) -> Array[int]:
	var wave_to_submit: Array[int] = []
	if challenge_rating != null && challenge_rating.size() > 0:
		wave_to_submit = wave_gen.get_wave(challenge_rating[wave_number])
	elif card_numbers != null && card_numbers.size() > 0:
		wave_to_submit = card_numbers[wave_number].wave
	return wave_to_submit