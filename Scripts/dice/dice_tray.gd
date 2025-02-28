extends HBoxContainer
class_name dice_tray

var slot_number = 1

@onready var dice_slot = preload("res://Scenes/dice_slot.tscn")
var slots:
	get:
		return get_tree().get_nodes_in_group("zones")

func _ready():
	get_tree().root.size_changed.connect(update_tray_area)
	signals.restarting.connect(reset)
	# reset()

func new_die() -> Node:
	if get_child_count() <= 0:
		return _add_slot()
	for slot in get_children():
		if slot.get_child(0).available:
			return slot.get_child(0)
	return _add_slot()

func _add_slot() -> Node:
	var instance = dice_slot.instantiate()
	add_child(instance)
	instance.name = "slot_"+str(slot_number)
	instance.get_child(0).setup_slot(slot_number)
	slot_number +=1
	return instance.get_child(0)

func update_tray_area() -> void:
	%dice_spawner.reset_positions()

func reset():
	slot_number = 1