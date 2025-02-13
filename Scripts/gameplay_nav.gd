extends Control

@export var startButton: Button
@export var nextRoundButton: Button
@export var endTurnButton: Button
var game_con: game_controller

func _ready():
	game_con = %game_controller
	startButton.pressed.connect(_start_game)
	nextRoundButton.pressed.connect(_next_round)
	endTurnButton.pressed.connect(_end_turn)

	signals.game_over.connect(disable_end_turn)
	signals.restarting.connect(enable_end_turn)
	signals.boss_fight.connect(boss_text_on)
	signals.boss_text_complete.connect(boss_text_end)


func _start_game():
	if game_con == null:
		game_con = %game_controller
	game_con.start_game()
	startButton.get_parent().hide()
	endTurnButton.get_parent().show()

func _next_round():
	if game_con == null:
		game_con = %game_controller
	signals.emit_next_round()
	endTurnButton.get_parent().show()
	nextRoundButton.get_parent().hide()

func _end_turn():
	if game_con == null:
		game_con = %game_controller
	signals.emit_turn_ended()

func disable_end_turn():
	endTurnButton.disabled = true

func enable_end_turn():
	endTurnButton.disabled = false

func boss_text_on(_null = null):
	endTurnButton.hide()

func boss_text_end(_null = null):
	endTurnButton.show()
