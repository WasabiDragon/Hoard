extends MarginContainer

func toggle_display():
	if visible:
		hide()
	else:
		show()