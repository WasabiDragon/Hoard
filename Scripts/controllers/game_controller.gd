extends Node
class_name game_controller


@export var flow: game_flow

func start_game():
	signals.emit_game_start()
	flow.start_level()
	flow.debug_lvl_num.hide()