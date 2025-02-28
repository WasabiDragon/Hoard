extends tooltip_template

@export var visibility_checker: VisibleOnScreenNotifier2D
@export var dice_class_label: Label
@export var dice_type_label: Label
@export var info_label: Label
var start_position: Vector2

func _ready():
	start_position = position

func update(value):
	var dice_stat_set = value as dice_stats
	dice_class_label.text = "Class: "+dice_stats.diceRole.keys()[dice_stat_set.role]
	dice_type_label.text = "Dice: "+dice_stats.diceType.keys()[dice_stat_set.type]
	var upgradeable_text = "Tier up progress: %d / %d until I become a %s" % [get_parent().get_parent().held_upgrades, dice_stats.diceType.values()[dice_stat_set.type]+1, dice_stats.diceType.keys()[dice_stat_set.type+1]]
	var max_upgrades_text = "The D100 cannot tier up further."
	info_label.text = upgradeable_text if dice_stat_set.upgradeable else max_upgrades_text

# func _process(delta):
	# if is_visible_in_tree():
	# 	visibility_checker.global_position = global_position
	# 	visibility_checker.global_position.x += size.x
	# 	if !visibility_checker.is_on_screen():
	# 		var starting = visibility_checker.global_position.x
	# 		while !visibility_checker.is_on_screen():
	# 			visibility_checker.global_position.x -=5
	# 		var ending = visibility_checker.global_position.x
	# 		global_position.x = global_position.x - abs(ending-starting) - 10
