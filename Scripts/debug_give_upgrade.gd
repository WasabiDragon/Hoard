extends Button


@export var upgrade_creator: upgrades_panel

func _ready():
	pressed.connect(turn_on_upgrades)

func turn_on_upgrades():
	upgrade_creator.show()
	upgrade_creator.set_choices()