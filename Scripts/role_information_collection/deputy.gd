extends role_information

func use_dice(info: dice_stats, target: Node) -> void:
	damager.apply_damage(target, info.current_roll)

var attacks_before_lock:
	get:
		return 1 + role_level