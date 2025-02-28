extends Button
class_name upgrade_box


@export var text_box: RichTextLabel
@export var image_box: TextureRect
# @export_enum("upgrade","role","extra","boss") var choice_type
enum button_job {
	upgrade,
	role,
	extra,
	boss
}

var button_type: button_job
var boss_upgrade_num