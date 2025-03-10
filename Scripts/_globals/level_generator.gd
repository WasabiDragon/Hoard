extends Node

@onready var _levelInfoPrefab = preload("res://Scripts/resources/level.gd")

var waves_per_tier = {
	0: [2,4],
	1: [3,6],
	2: [4,7],
	3: [4,8],
	4: [5,8],
	5: [5,9],
	6: [6,10],
	7: [6,11],
	8: [7,12],
	9: [8,12],
	10: [8,13]
}

## tiers are between 1 and 10 and will increase towards max tier as the level progresses
func create_level(levelSize: int, minTier: int, maxTier: int, bossTier: int) -> level:
	var level_info = _levelInfoPrefab.new()
	var tier_increase_per_level: float = (float(maxTier) - float(minTier)) / float(levelSize)
	var current_tier = minTier
	for n in levelSize:
		var output_round = round_gen.create_round(waves_per_tier[roundi(current_tier)][randi() % waves_per_tier[roundi(current_tier)].size()],roundi(current_tier), n % 2 != 0)
		level_info.rounds.append(output_round)
		current_tier += tier_increase_per_level
	var with_boss = round_gen.add_boss_to_round(level_info.rounds[-1],bossTier)
	if with_boss == null:
		print("Level creation failed")
		return null
	else:
		level_info.rounds[-1] = with_boss
	return level_info