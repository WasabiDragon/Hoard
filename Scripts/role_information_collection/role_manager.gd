extends Node
class_name role_manager

@export var damageCalculator: damage_calc
var _roles:= []

func _ready():
	_roles = get_children()

func get_dice_face(info: dice_stats) -> String:
	return "?" if info.role == dice_stats.diceRole.Deadeye else str(info.current_roll)

# func aoe_enabled(info:dice_stats) -> bool:
# 	return info.role == dice_stats.diceRole.Demolisher

func get_dice_image(info:dice_stats) -> Texture2D:
	return select_die(info.role).get_dice_image(info.type)

func get_role_image(info: dice_stats.diceRole) -> Texture2D:
	return select_die(info).get_role_image()

func use_dice(info: dice_stats, target: Node):
	select_die(info.role).use_dice(info,target)

func select_die(info:dice_stats.diceRole) -> role_information:
	for role_info: role_information in _roles:
		if role_info.role == info:
			return role_info
	push_error("Failed to find dice role.")
	return null

func get_multi_roll(info:dice_stats) -> int:
	if info.role == dice_stats.diceRole.Deputy:
		return select_die(info.role).attacks_before_lock
	else:
		return 1

func get_lockout_time(info:dice_stats) -> int:
	return select_die(info.role).dice_cooldown

func get_role_text(info: dice_stats.diceRole) -> String:
	return select_die(info).role_description

func get_upgrade_text(info: dice_stats.diceRole) -> String:
	return select_die(info).upgrade_description

func upgrade_role(info: dice_stats.diceRole):
	select_die(info).role_level += 1

func get_role_color(info: dice_stats.diceRole) -> Color:
	return select_die(info).role_color

func quickshot_distance() -> int:
	return select_die(dice_stats.diceRole.Quickshot).distance

func get_font_color(info: dice_stats.diceRole) -> Color:
	return select_die(info).dice_font_color