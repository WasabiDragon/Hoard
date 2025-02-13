extends HBoxContainer
class_name dice_tray

@onready var dice_slot = preload("res://Scenes/dice_slot.tscn")

func _ready():
	get_tree().root.size_changed.connect(update_tray_area)
	reset()

func new_die() -> Node:
	for slot in get_children():
		if slot.get_child(0).available:
			return slot.get_child(0)
	return _add_slot()

func reset() -> void:
	for child in get_children():
		child.queue_free()
	for n in stats.max_dice:
		_add_slot()

func _add_slot() -> Node:
	var instance = dice_slot.instantiate()
	add_child(instance)
	instance.name = "slot_"+str(get_child_count())
	return instance.get_child(0)

func update_tray_area() -> void:
	for slot in get_children():
		var drop_point = slot.get_child(0)
		drop_point.currentNode = null
	%dice_spawner.reset_positions()