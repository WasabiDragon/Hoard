extends TextureButton

@export var start_image: Texture2D
@export var next_level_image: Texture2D
@export var overlay: ColorRect

func _ready():
	pressed.connect(_start_game)
	texture_normal = start_image
	mouse_entered.connect(hover_overlay_on)
	mouse_exited.connect(hover_overlay_off)

func _start_game():
	%timing_controller.start_game()
	hide()
	texture_normal = next_level_image
	pressed.disconnect(_start_game)
	pressed.connect(_next_level)

func _next_level():
	%timing_controller.next_level()
	hide()

func hover_overlay_on():
	overlay.show()

func hover_overlay_off():
	overlay.hide()