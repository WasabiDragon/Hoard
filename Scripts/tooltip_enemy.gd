extends tooltip_template

@export var current_hp_label: Label
@export var max_hp_label: Label

func update(value):
	current_hp_label.text = value[0]
	max_hp_label.text = value[1]
