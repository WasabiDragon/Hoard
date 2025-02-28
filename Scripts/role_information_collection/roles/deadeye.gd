extends role_information

func use_dice(info: dice_stats, target: Node) -> void:
	damager.apply_damage(target, ceili(info.current_roll * (damage_mult*role_level)))