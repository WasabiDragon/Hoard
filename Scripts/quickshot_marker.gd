extends ColorRect

@export var role_mgr: role_manager

func _ready():
	signals.quickshot.connect(line_visibility)
	signals.restarting.connect(hide)
	get_tree().root.size_changed.connect(set_position)

func line_visibility():
	var has_quickshot: bool = false
	for dice in get_tree().get_nodes_in_group("dice"):
		if dice.dice.role == dice_stats.diceRole.Quickshot:
			has_quickshot = true
	if has_quickshot:
		find_target_position()
		show()
	else:
		hide()

func find_target_position():
	var parent_height = get_parent().size.y
	var lanes = stats.lanes
	var rows_from_front = role_mgr.quickshot_distance()
	var lane_height = parent_height / lanes
	var target_height = get_parent().global_position.y + (lane_height * (lanes - rows_from_front))
	global_position = Vector2(global_position.x, target_height)