extends Control
class_name game_over_panel

@export var timing_panel: timing_controller
@export var restartButton: Button
@export var bigWriting: Label

func _ready():
	restartButton.pressed.connect(replay)

func replay():
	timing_panel.restart()
	hide()
	bigWriting.text = "GAME OVER"
	bigWriting.label_settings.font_color = Color.WHITE

func victory():
	bigWriting.text = "Victory!"
	bigWriting.label_settings.font_color = Color.LIME_GREEN
