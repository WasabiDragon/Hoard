extends tooltip_template

@export var dice_class_label: Label
@export var dice_type_label: Label
@export var info_label: Label

func update(value):
	var dice_stat_set = value as dice_stats
	dice_class_label.text = "Class: "+dice_stats.diceRole.keys()[dice_stat_set.role]
	dice_type_label.text = "Dice: "+dice_stats.diceType.keys()[dice_stat_set.type]
	info_label.text = "This is where informational text would display."