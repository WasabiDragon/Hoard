extends Node

var total_max_challenge = 500
@onready var _roundInfoPrefab = preload("res://Scripts/resources/round_info.gd")

var additional_blank_wave_chance = 0.25
var blank_wave_reduce = 0.05


##Difficulty is based on tiers. T0 = easiest T10 = hardest
func create_round(waves: int, tier: int, rewards: bool = false) -> round_info:
	var instance:round_info = _roundInfoPrefab.new()
	var remaining:int = randi_range(globals.difficulties_per_wave[tier][0],globals.difficulties_per_wave[tier][1])
	instance.round_challenge_rating = remaining
	if waves <= 1:
		instance.challenge_rating.append(remaining)
		return instance

	var generated_waves: Array[int] = []
	var max_in_one_wave:int = round((float(remaining) / float(waves)) *2.0)
	var blank_wave_chance = additional_blank_wave_chance
	for n in waves-1:
		var _selected_challenge = randi_range(0,max_in_one_wave if max_in_one_wave < remaining else remaining)
		generated_waves.append(_selected_challenge)
		remaining -= _selected_challenge
		if randf() < blank_wave_chance:
			generated_waves.append(0)
			blank_wave_chance -= blank_wave_reduce
	generated_waves.append(remaining)

	generated_waves = _remove_extra_empties(generated_waves)
	
	instance.challenge_rating = generated_waves
	instance.round_type = round_info.type.Challenge_Rating
	instance.has_rewards = rewards
	return instance

func _remove_extra_empties(target: Array[int]) -> Array[int]:
	while target[-1] == 0:
		target.remove_at(target.size()-1)
	target.reverse()
	while target[-1] == 0:
		target.remove_at(target.size()-1)
	target.reverse()
	var zeros_in_row = 0
	var index_to_remove = []
	for n in target.size():
		if target[n] == 0:
			zeros_in_row +=1
		else:
			zeros_in_row = 0
		if zeros_in_row > 1:
			index_to_remove.append(n)
	index_to_remove.reverse()
	for n in index_to_remove.size():
		target.remove_at(index_to_remove[n])

	return target
	
##Difficulty is based on tiers. T0 = easiest T10 = hardest
func add_random_boss_to_round(roundInfo: round_info, bossDifficulty: int) -> round_info:
	var difficulty = ceili((float(globals.enemy_difficulties.size()) / 10) *10*(bossDifficulty+1))
	var selected_boss = boss_gen.generate_boss(difficulty)
	return add_specific_boss_to_round(roundInfo, selected_boss)
		
func add_specific_boss_to_round(roundInfo:round_info, bossRound: boss_round) -> round_info:
	roundInfo.boss = bossRound
	roundInfo.has_boss = true
	roundInfo.has_rewards = false
	return roundInfo