extends Node
class_name globals_master

var starting_dice: int = 2
var max_dice_default: int = 5

var _current_max_dice: int = 5

var lanes = 8
var ranks = 9

var debug_enabled:
	get:
		var output = $/root/Main.debug_mode
		return output

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

var max_levels: int = 11

var consumable_knockback_enabled: bool = false
var consumable_freeze_enabled: bool = false
var consumable_freeze_toggle: bool = false
var consumable_max_rolls_enabled: bool = false
var consumable_tier_up_enabled:bool = false

var waves_per_level: Dictionary ={
	0: [2,4],
	1: [2,5],
	2: [2,6],
	3: [3,7],
	4: [3,8],
	5: [3,9],
	6: [4,9],
	7: [4,10],
	8: [4,10],
	9: [4,10],
	10: [4,10]
}

var difficulties_per_wave: Dictionary = {
	0: [1,8],
	1: [6,17],
	2: [13,30],
	3: [25,60],
	4: [50,95],
	5: [80,135],
	6: [120, 180],
	7: [160,230],
	8: [200, 300],
	9: [260,470],
	10:[430,550]
}

var enemy_difficulties: Dictionary = {
	1:[1,2,3],
	2:[4,5,6],
	3:[6,7,8],
	4:[9,10],
	5:[10],
	20:["wagon_easy", 0],
	25:[11],
	31:[12],
	35:["wagon_medium", 1],
	37:[13],
	50:["wagon_hard", 2],
	90:["wagon_royal", 3]
}