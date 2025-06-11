extends tooltip_template

@export var text_section: RichTextLabel
	
func update(value) -> void:
	text_section.text = value
