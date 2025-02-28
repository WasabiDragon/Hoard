extends role_information

func use_dice(info: dice_stats, target: Node) -> void:
	damager.apply_damage(target, info.current_roll)

var distance: int:
	get:
		return role_level + upgrade_modifier