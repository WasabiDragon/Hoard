extends Control

@export var text: Label
@export var flow: game_flow

func _ready():
	signals.turn_ended.connect(update_display)
	signals.title_complete.connect(initialize_display)
	signals.boss_text_complete.connect(initialize_display)

func update_display():
	var waves_in_round = flow.get_remaining_waves()
	var current_wave = flow._currentWave
	var remaining_waves = 0 if waves_in_round - current_wave <= 0 else waves_in_round - current_wave
	if remaining_waves > 0:
		show()
		text.text = str(remaining_waves)
	else:
		hide()

func initialize_display():
	var waves_in_round = flow.get_remaining_waves()
	var current_wave = flow._currentWave
	var remaining_waves = 0 if waves_in_round - current_wave <= 0 else waves_in_round - current_wave
	if remaining_waves-1 > 0:
		show()
		text.text = str(remaining_waves-1)
	else:
		hide()