extends PanelContainer
class_name consumable_panel

@export var consumableImage: TextureRect
@export var consumableHighlightImage: TextureRect
@export var timer: Node
@export var timerText: Label
@onready var consumable_mgr:= $/root/Main/game_controller/consumables_manager
var _consumable: consumable
var countdown_enabled:=false

func _ready():
	signals.next_round.connect(_update_countdown)

func set_consumable(consumable_resource: consumable):
	_consumable = consumable_resource
	consumableImage.texture = consumable_resource.image
	consumableImage.show()
	consumableHighlightImage.texture = consumable_resource.highlight_image
	consumableHighlightImage.hide()
	$custom_tooltip.update_tooltip(_consumable.description)
	if _consumable.type == consumable_manager.consumableType.KILL_ALL:
		timer.show()
		timerText.text = str(_consumable.uses)

func _gui_input(event):
	if event.is_action("click") && globals.game_running && (!_consumable.active || _consumable.type == consumable_manager.consumableType.KILL_ALL):
		signals.emit_use_consumable(_consumable)
		match _consumable.type:
			consumable_manager.consumableType.KNOCKBACK:
				_enable_countdown()
			consumable_manager.consumableType.KILL_ALL:
				_reduce_count()
			consumable_manager.consumableType.FREEZE:
				_enable_countdown()
			consumable_manager.consumableType.MAX_ROLL:
				_enable_countdown()
			consumable_manager.consumableType.TIER_UP:
				_enable_countdown()

func _on_mouse_enter():
	if _consumable.active && _consumable.type != consumable_manager.consumableType.KILL_ALL:
		return
	consumableHighlightImage.show()

func _on_mouse_exit():
	consumableHighlightImage.hide()

func _enable_countdown():
	_update_countdown()
	timer.show()

func _update_countdown():
	if !_consumable.active || _consumable.type == consumable_manager.consumableType.KILL_ALL:
		return
	if _consumable.uses <= 0:
		consumable_mgr.disable_powerup(consumable_manager.consumableType.keys()[_consumable.type])
		queue_free()
	_consumable.uses -= 1
	timerText.text = str(_consumable.uses)

func _reduce_count():
	_consumable.uses -= 1
	timerText.text = str(_consumable.uses)
	if _consumable.uses <= 0:
		queue_free()