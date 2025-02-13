extends VisibleOnScreenNotifier2D

var _timer: float = 0

func _ready():
	screen_exited.connect(destroy_obj)

func destroy_obj():
	get_parent().queue_free()

func _process(delta):
	if !is_on_screen():
		_timer += delta
	else:
		_timer = 0
	if _timer > 3:
		destroy_obj()