@tool
extends Button

@export var text_object: RichLabelAutoSizer
signal changed

@export var buttonText: String:
	set(value):
		buttonText = value
		if text_object != null:
			text_object.text = buttonText
		changed.emit()

func _on_mouse_entered():
	if text_object != null:
		text_object.add_theme_color_override("default_color",theme.get_color("font_hover_color","Button"))

func _on_mouse_exited():
	if text_object != null:
		text_object.add_theme_color_override("default_color",theme.get_color("font_color","Button"))

func _on_pressed():
	if text_object != null:
		text_object.add_theme_color_override("default_color",theme.get_color("font_pressed_color","Button"))
