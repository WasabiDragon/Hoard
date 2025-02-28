extends PanelContainer

@export var role_mgr: role_manager
@export var display_lines: Array[class_info_line]

func _ready():
	get_parent().pressed.connect(display_help)

func display_help():
	if visible:
		hide()
	else:
		set_display_lines()
		show()

func set_display_lines():
	var roles = dice_stats.diceRole.keys()
	var line_num = 0
	for n in roles.size():
		if dice_stats.diceRole[roles[n]] == dice_stats.diceRole.Cowboy:
			continue
		else:
			display_lines[line_num].set_display_line(role_mgr.get_role_image(dice_stats.diceRole[roles[n]]),role_mgr.get_role_text(dice_stats.diceRole[roles[n]]))
			line_num+=1


