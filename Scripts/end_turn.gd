extends TextureButton

@export var overlay: ColorRect

func _ready():
	pressed.connect(_end_turn)
	mouse_entered.connect(hover_overlay_on)
	mouse_exited.connect(hover_overlay_off)

func _end_turn():
	%timing_controller._end_turn()

func hover_overlay_on():
	overlay.show()

func hover_overlay_off():
	overlay.hide()