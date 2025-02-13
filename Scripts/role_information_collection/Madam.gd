extends role_information

@export var _dice_spawner: dice_spawner

func use_dice(info: dice_stats, target: Node) -> void:
	damager.apply_damage(target, info.current_roll)
	_reduce_lockout(info)

func _reduce_lockout(dice_input: dice_stats) -> void:
	for n in role_level:
		var dice_list = []
		for child: dice_object in _dice_spawner.get_children():
			if child.locked_out && child.dice != dice_input:
				dice_list.append(child)
		if dice_list != null && dice_list.size() > 0:
			dice_list[randi() % dice_list.size()].reduce_lockout()
