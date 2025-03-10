extends Resource
class_name reward_obj

enum reward_tier{NONE, STANDARD, BOSS}
enum reward{EMPTY,DIE,ROLE,TIER_UP}

var tier: reward_tier = reward_tier.NONE
var type: reward = reward.EMPTY
var role: dice_stats.diceRole

func set_random_role(ownedRoles: Array[dice_stats.diceRole] = []):
	var roleList = []
	if ownedRoles.is_empty():
		roleList = dice_stats.diceRole.keys()
		roleList.erase(dice_stats.diceRole.Cowboy)
		role = dice_stats.diceRole[roleList[randi() % roleList.size()]]
	else:
		role = ownedRoles[randi()%ownedRoles.size()]