extends Node

@export var debug_mode:= false
@export var build_number: String
@export var build_number_label: Label
@export var kill_button: Button

func _ready():
	build_number_label.text = build_number
	signals.game_start.connect(hide_build_num)
	if !debug_mode:
		return
	kill_button.show()

func hide_build_num():
	if !debug_mode:
		build_number_label.hide()
	signals.game_start.disconnect(hide_build_num)