extends Node

@export var starting_spawn = 2
@onready var _dice_obj = preload("res://Scenes/dice_obj.tscn")
var _initialized = false

func _process(delta):
	if !_initialized:
		if get_tree().get_nodes_in_group("zones")[0].global_position.x != 0:
			_initialize()


func _initialize():
	for n in starting_spawn:
		spawn_die()
	_initialized = true

func spawn_die():
	var instance = _dice_obj.instantiate()
	add_child(instance)
	for slot in get_tree().get_nodes_in_group("zones"):
		if slot.available:
			instance.global_position = slot.global_position
			slot.place(instance)
			print("placed die at: "+str(slot.global_position))
			break
	