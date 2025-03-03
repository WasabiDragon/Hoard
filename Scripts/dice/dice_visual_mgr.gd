extends Node
class_name dice_visual_mgr

@export var label: Label
@export var dice_sprite: Sprite2D
@export var dice_class_image: Sprite2D

func set_dice(texture: Texture2D):
	dice_sprite.texture = texture

func set_class(texture: Texture2D):
	dice_class_image.texture = texture

func set_face(display: String):
	label.text = display

func set_font_color(fontColor: Color):
	label.add_theme_color_override("font_color", fontColor)