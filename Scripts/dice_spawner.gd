extends Node
class_name dice_spawner

@export var starting_spawn = 2
@onready var _dice_obj = preload("res://Scenes/dice_obj.tscn")
var _initialized = false
var _spawnedDice = 1

func _process(_delta):
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
	instance.dice = dice_stats.new()
	instance.dice.Initialize()
	instance.dice.name = "diceRes_"+str(_spawnedDice)
	instance.name = "Dice_"+str(_spawnedDice)
	instance.set_image()
	_spawnedDice +=1
	for slot in get_tree().get_nodes_in_group("zones"):
		if slot.available:
			instance.global_position = slot.global_position
			slot.place(instance)
			print("placed die at: "+str(slot.global_position))
			break
	
func restart():
	for dice in get_tree().get_nodes_in_group("dice"):
		dice.queue_free()
	for zone in get_tree().get_nodes_in_group("zones"):
		zone.currentNode = null
	_initialize()

func refresh_dice():
	for dice in get_tree().get_nodes_in_group("dice"):
		dice.refresh_lockout()