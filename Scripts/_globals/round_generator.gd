extends Node

var total_max_challenge = 500
@onready var _roundInfoPrefab = preload("res://Scripts/resources/round_info.gd")

var additional_blank_wave_chance = 0.25
var blank_wave_reduce = 0.05

var difficulties = {
	0: [1,5],
	1: [5,10],
	2: [10,20],
	3: [20,35],
	4: [35,50],
	5: [50,70],
	6: [70, 100],
	7: [100,230],
	8: [230, 320],
	9: [320,400],
	10:[400,500]
}


##Difficulty is based on tiers. T0 = easiest T10 = hardest
func create_round(waves: int, tier: int, rewards: bool = false) -> round_info:
	var instance:round_info = _roundInfoPrefab.new()
	var remaining:int = randi_range(difficulties[tier][0],difficulties[tier][1])
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
func add_boss_to_round(roundInfo: round_info, bossDifficulty: int) -> round_info:
	var boss_list: Array[boss_obj] = $/root/Main/game_controller/boss_list.bosses
	var boss_cat: boss_obj = null
	for obj in boss_list:
		if obj == null:
			return null
		if (obj.tier == null && bossDifficulty == 0) || obj.tier == bossDifficulty:
			boss_cat = obj
			break
	if boss_cat.bosses == null || boss_cat.bosses.size() <=0:
		print("no bosses found")
		return null
	var selected_boss: boss_round = boss_cat.bosses[randi() % boss_cat.bosses.size()]
	roundInfo.boss = selected_boss
	roundInfo.has_boss = true
	roundInfo.has_rewards = false
	return roundInfo
		