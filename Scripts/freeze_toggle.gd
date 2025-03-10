extends Button

func _ready():
	toggled.connect(enable_freeze)

func enable_freeze(mode_on):
	stats.consumable_freeze_toggle = mode_on