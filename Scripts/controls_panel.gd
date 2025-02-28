extends PanelContainer

func _ready():
	get_parent().pressed.connect(display_help)

func display_help():
	if visible:
		hide()
	else:
		show()