extends Node
class_name floating_text


@onready var floatingText = preload("res://Scenes/popup_text.tscn")

func spawn_text(position: Vector2, words: String, targetCol: Color = Color.WHITE):
	var instance = floatingText.instantiate()
	add_child(instance)
	instance.global_position = position
	instance.text = words
	instance.label_settings.font_color = targetCol
	instance.set_start()
