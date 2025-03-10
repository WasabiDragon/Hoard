extends Node

@onready var reward_prefab = preload("res://Scripts/reward_object.gd")

func generate_boss_rewards(count:int) -> Array[reward_obj]:
	var roles_to_upgrade: Array[dice_stats.diceRole] = []
	for die in get_tree().get_nodes_in_group("dice"):
		if die.dice.role != dice_stats.diceRole.Cowboy && !roles_to_upgrade.has(dice_stats.diceRole.values()[die.dice.role]):
			roles_to_upgrade.append(dice_stats.diceRole.values()[die.dice.role])
	var rewards:Array[reward_obj] = []
	if roles_to_upgrade.size() + 1 < count:
		count = roles_to_upgrade.size() + 1
	for n in count:
		var instance = reward_prefab.new()
		instance.tier = reward_obj.reward_tier.BOSS
		if n != 0:
			instance.role = roles_to_upgrade.pop_at(randi() % roles_to_upgrade.size())
			instance.type = reward_obj.reward.ROLE
		else:
			instance.type = reward_obj.reward.DIE
		rewards.append(instance)
	return rewards

func generate_standard_rewards(count: int = 3):
	var rewards: Array[reward_obj] = []
	var roles = []
	for role in dice_stats.diceRole.values():
		if role != dice_stats.diceRole.Cowboy:
			roles.append(role)
	for n in count:
		var instance = reward_prefab.new()
		instance.tier = reward_obj.reward_tier.STANDARD
		if n == 0:
			instance.type = reward_obj.reward.TIER_UP
		else:
			instance.type = reward_obj.reward.ROLE
			instance.role = roles.pop_at(randi() % roles.size())
		rewards.append(instance)
	return rewards
