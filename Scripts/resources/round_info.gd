extends Resource
class_name round_info

@export_group("Basic Waves")
enum type {Challenge_Rating,Pregenerated}
@export var has_rewards:bool = false
@export var round_type: type
@export var challenge_rating: Array[int] = []
@export var card_numbers: Array[pregenerated_wave] = []

@export_group("Boss Info")
@export var has_boss: bool = false
@export var boss: Array[boss_round] = []

func is_wave_in_round(wave_index) -> bool:
	var biggest_array = challenge_rating.size() if round_type == type.Challenge_Rating else card_numbers.size()
	if wave_index >= biggest_array:
		return false
	else:
		return true

func get_wave(wave_number) -> pregenerated_wave:
	var wave_to_submit: pregenerated_wave
	wave_to_submit = wave_gen.get_wave(challenge_rating[wave_number]) if round_type == type.Challenge_Rating else card_numbers[wave_number]
	return wave_to_submit