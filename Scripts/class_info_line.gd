extends Control
class_name class_info_line

@export var image_holder: TextureRect
@export var text_section: RichTextLabel

func set_display_line(texture: Texture2D, text: String):
	image_holder.texture = texture
	text_section.text = text