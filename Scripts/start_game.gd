extends Button


func _ready():
	pressed.connect(_start_game)

func _start_game():
	%timing_controller.start_game()
	hide()
