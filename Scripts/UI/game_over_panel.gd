extends Control
class_name game_over_panel

@export var timing_panel: game_controller
@export var restartButton: Button
@export var bigWriting: Label
@export var extra_text: Label

func _ready():
	restartButton.pressed.connect(replay)
	signals.game_over.connect(show)

func replay():
	signals.emit_restarting()
	hide()
	bigWriting.text = "GAME OVER"
	extra_text.hide()
	bigWriting.label_settings.font_color = Color.WHITE

func victory():
	bigWriting.text = "Victory!"
	extra_text.show()
	bigWriting.label_settings.font_color = Color.LIME_GREEN
