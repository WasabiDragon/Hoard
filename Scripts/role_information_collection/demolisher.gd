extends role_information

@export var enemy_spawner: spawner
var explosion_radius
func use_dice(info: dice_stats, target: Node) -> void:
	for spawned_enemy in enemy_spawner.spawn_parent.get_children():
		var gridDiff = spawned_enemy.gridPosition - target.gridPosition
		var inRange: bool = (
			(gridDiff.y >= -role_level &&
			gridDiff.y <= role_level) &&
			(gridDiff.x >= -role_level &&
			gridDiff.x <= role_level)
			)
		if inRange :
			damager.apply_damage(spawned_enemy, info.current_roll)