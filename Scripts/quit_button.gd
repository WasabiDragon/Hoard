extends Button

func exit_game():
	print("Attempting quit")
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)