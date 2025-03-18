extends Node
	
func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		print("Quitting")
		get_tree().quit() # default behavior