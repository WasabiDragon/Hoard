extends Node2D
class_name droppable_upgrade

var _selected: bool = false
@export var upgrade_distance = 100
@export var type: upgradeType
@export var role: dice_stats.diceClass
@onready var _audio_bank = $success_sound as audio_bank

enum upgradeType	
{
	upgrade,
	diceClass,
	extraDie
}



func _on_area_2d_input_event(_viewport, _event, _shape_idx):
	#implement pickup behaviour
	if Input.is_action_just_pressed("click"):
		_selected = true

func _input(event):
	#implement dropping behaviour
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			_upgrade_dice()
			var _check = _check_for_dice(32)
			if _check != null:
				global_position -= global_position.direction_to(_check.global_position) * 64
			_selected = false


func _physics_process(delta):
	#implement dragging behaviour
	if _selected:
		global_position = lerp(global_position, get_global_mouse_position(), 25*delta)

func _upgrade_dice():
	var _target = _check_for_slot(upgrade_distance) if type == upgradeType.extraDie else _check_for_dice(upgrade_distance)
	if _target != null:
		if get_parent().upgrade(_target, type, role):
			_audio_bank.finished.connect(_destroy_self)
			_audio_bank.play_from_list()

func _destroy_self():
	queue_free()

func _check_for_dice(distance):
	for dice in get_tree().get_nodes_in_group("dice"):
		if global_position.distance_to(dice.global_position) <= distance:
			return dice
	return null

func _check_for_slot(distance):
	for slot in get_tree().get_nodes_in_group("rolling_slot"):
		if global_position.distance_to(slot.global_position) <= distance && slot.available:
			return slot
	return null