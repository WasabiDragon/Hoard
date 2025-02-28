extends Node
class_name stats_master

var starting_dice: int = 2
var max_dice_default: int = 5

var _current_max_dice: int = 5

var lanes = 8
var ranks = 9

var max_dice: int:
	get:
		return _current_max_dice if _current_max_dice > max_dice_default else max_dice_default
	set(value):
		_current_max_dice = value

var sfx_volume: float:
	get:
		return sfx_volume / 100
	set(value):
		sfx_volume = value
		signals.emit_SFX_volume_changed()

var music_volume: float:
	get:
		return music_volume /100
	set(value):
		music_volume = value
		signals.emit_music_volume_changed()

var max_music_volume: float:
	get:
		return max_music_volume /100

var game_running: bool:
	get:
		return game_running
	set(value):
		game_running = value

var dice_selected: bool:
	get:
		return dice_selected
	set(value):
		dice_selected = value