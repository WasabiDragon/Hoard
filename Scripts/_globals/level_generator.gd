extends Node

@onready var _levelInfoPrefab = preload("res://Scripts/resources/level.gd")


## tiers are between 1 and 10 and will increase towards max tier as the level progresses
func create_level(levelSize: int, minTier: int, maxTier: int, bossTier: int) -> level:
	var level_info = _levelInfoPrefab.new()
	var tier_increase_per_level: float = (float(maxTier) - float(minTier)) / float(levelSize)
	var current_tier = minTier
	for n in levelSize:
		var waves_in_round = randi_range(globals.waves_per_level[roundi(current_tier)][0],globals.waves_per_level[roundi(current_tier)][1])
		var output_round = round_gen.create_round(waves_in_round,roundi(current_tier),false)
		level_info.rounds.append(output_round)
		current_tier += tier_increase_per_level
	level_info.rounds.sort_custom(func(a,b): return a.round_challenge_rating <= b.round_challenge_rating)
	for n in level_info.rounds.size():
		if n % 2 != 0:
			level_info.rounds[n].has_rewards = true
	var with_boss = round_gen.add_random_boss_to_round(level_info.rounds[-1],bossTier)
	if with_boss == null:
		print("Level creation failed")
		return null
	else:
		level_info.rounds[-1] = with_boss
	return level_info

func add_boss_manually_to_level(levelObj: level, bossRound: boss_round) -> level:
	var with_boss = round_gen.add_specific_boss_to_round(levelObj.rounds[-1],bossRound)
	if with_boss == null:
		print("Level creation failed")
		return null
	else:
		levelObj.rounds[-1] = with_boss
	return levelObj