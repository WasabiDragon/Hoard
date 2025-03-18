extends Control
class_name boss_upgrade_screen

@export var icon: TextureRect
@export var text: RichLabelAutoSizer
@export var button:Button

signal boss_upgrade_display_complete
signal confirmed

func _ready():
	button.pressed.connect(confirm)
	
func _set_display(texture: Texture2D, description: String):
	icon.texture = texture
	text.text = description

func display_boss_upgrade(texture: Texture2D, description: String):
	_set_display(texture,description)
	show()
	text.text = text.text
	await confirmed
	hide()
	boss_upgrade_display_complete.emit()

func _input(event):
	if event.is_action("ui_accept"):
		confirm()

func confirm():
	confirmed.emit()