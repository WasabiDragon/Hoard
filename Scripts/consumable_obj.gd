extends PanelContainer
class_name consumable_panel

@export var consumableImage: TextureRect
@export var consumableHighlightImage: TextureRect
var _consumable: consumable

func set_consumable(consumable_resource: consumable):
	_consumable = consumable_resource
	consumableImage.texture = consumable_resource.image
	consumableImage.show()
	consumableHighlightImage.texture = consumable_resource.highlight_image
	consumableHighlightImage.hide()

func _input(event):
	if event.is_action("click") && stats.game_running:
		signals.emit_use_consumable(_consumable)
		queue_free()

func mouse_entered():
	consumableHighlightImage.show()

func mouse_exited():
	consumableHighlightImage.hide()