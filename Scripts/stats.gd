extends Node
class_name stats_master

var starting_dice: int = 1
var max_dice_default: int = 5

var _current_max_dice: int = 5

var max_dice: int:
	get:
		return _current_max_dice if _current_max_dice > max_dice_default else max_dice_default
	set(value):
		_current_max_dice = value