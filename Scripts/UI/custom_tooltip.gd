extends Control
class_name custom_tooltip

@onready var tooltip_box = get_child(0)
@export var tooltip_wait_time = 0.5
var mouse_inside:= false
var mouse_inside_time = 0
var mouse_held:= false

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			mouse_held = false
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			mouse_held = true
			tooltip_box.hide()
			mouse_inside_time = 0

func update_tooltip(value):
	if typeof(tooltip_box.get_script()) != typeof(tooltip_template):
		print("Tooltip not implemented")
	else:
		tooltip_box.update(value)


func _process(delta):
	if mouse_inside and not mouse_held:
		mouse_inside_time += delta
	if !tooltip_box.visible && mouse_inside_time >= tooltip_wait_time:
		tooltip_box.show()
	elif tooltip_box.visible && mouse_inside_time < tooltip_wait_time:
		tooltip_box.hide()


func _on_mouse_entered():
	mouse_inside = true

func _on_mouse_exited():
	mouse_inside = false
	mouse_inside_time = 0
