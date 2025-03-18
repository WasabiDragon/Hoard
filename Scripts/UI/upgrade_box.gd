extends Button
class_name upgrade_box


@export var text_box: RichTextLabel
@export var image_box: TextureRect
@export var colorRectMouseOver: ColorRect
@export var colorRectFocus: ColorRect
@export var panel_number: Label

enum button_job {
	upgrade,
	role,
	extra,
	boss
}

var button_type: button_job
var boss_upgrade_num

func bring_focus():
	grab_focus()

func show_mouse_over():
	colorRectMouseOver.show()

func hide_mouse_over():
	colorRectMouseOver.hide()

func focus_display_enable():
	colorRectFocus.show()

func focus_display_disable():
	colorRectFocus.hide()

func set_panel_num(number: int):
	panel_number.text = str(number)