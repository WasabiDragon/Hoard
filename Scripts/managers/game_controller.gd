extends Node
class_name game_controller


@export var flow: game_flow

func _ready():
	connect_signals()

func connect_signals():
	signals.restarting.connect(start_game)

func start_game():
	signals.emit_game_start()
	flow.start_level()
	flow.debug_lvl_num.hide()