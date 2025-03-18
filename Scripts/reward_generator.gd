extends Node

@onready var reward_prefab = preload("res://Scripts/reward_object.gd")
@onready var consumable_mgr: consumable_manager = $/root/Main/game_controller/consumables_manager 

func generate_boss_rewards(count:int) -> Array[reward_obj]:
	var rewards_to_produce = count
	var roles_to_upgrade: Array[dice_stats.diceRole] = _get_available_roles()
	var rewards:Array[reward_obj] = []
	if get_tree().get_nodes_in_group("dice").size() < globals.max_dice:
		rewards.append(_get_dice_reward())
		rewards_to_produce -=1
	for n in rewards_to_produce:
		var rewards_split: Array[reward_obj] = []
		if roles_to_upgrade.size() > 0:
			rewards_split.append(_get_roles_reward(roles_to_upgrade.pop_at(randi() % roles_to_upgrade.size())))
		rewards_split.append(_get_consumables_reward())
		rewards.append(rewards_split[randi() % rewards_split.size()])
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

func _get_available_roles() -> Array[dice_stats.diceRole]:
	var available_roles: Array[dice_stats.diceRole] = []
	for die in get_tree().get_nodes_in_group("dice"):
		if die.dice.role != dice_stats.diceRole.Cowboy && !available_roles.has(dice_stats.diceRole.values()[die.dice.role]):
			available_roles.append(dice_stats.diceRole.values()[die.dice.role])
	return available_roles

func _get_dice_reward() -> reward_obj:
	var instance = reward_prefab.new()
	instance.tier = reward_obj.reward_tier.BOSS
	instance.type = reward_obj.reward.DIE
	return instance

func _get_roles_reward(role: dice_stats.diceRole) -> reward_obj:
	var instance = reward_prefab.new()
	instance.tier = reward_obj.reward_tier.BOSS
	instance.type = reward_obj.reward.ROLE
	instance.role = role
	return instance

func _get_consumables_reward() -> reward_obj:
	var instance = reward_prefab.new()
	instance.tier = reward_obj.reward_tier.BOSS
	instance.type = reward_obj.reward.CONSUMABLE
	instance.consumable_reward = consumable_mgr.get_random_consumable()
	return instance