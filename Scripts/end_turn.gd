extends Button

func _ready():
	pressed.connect(_end_turn)
	
func _end_turn():
	%timing_controller._end_turn()
