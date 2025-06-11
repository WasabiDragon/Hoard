extends Button

func _ready():
	toggled.connect(enable_freeze)
	signals.next_round.connect(disable_freeze)

func enable_freeze(mode_on):
	globals.consumable_freeze_toggle = mode_on

func disable_freeze():
	globals.consumable_freeze_toggle = false
	set_pressed_no_signal(false)