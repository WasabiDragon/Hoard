extends Node
class_name dice_spawner

@export var tray: dice_tray
@export var role_mgr: role_manager
@onready var _dice_obj = preload("res://Scenes/dice_obj.tscn")
var _initialized = false
var _spawnedDice = 1
var _started = false

func _ready():
	connect_signals()

func connect_signals():
	signals.restarting.connect(restart)
	signals.game_start.connect(_game_start)
	
func _game_start():
	_started = true

func _process(_delta):
	if !_initialized && _started:
		# if get_tree().get_nodes_in_group("zones").size() > 0 && get_tree().get_nodes_in_group("zones")[0].global_position.x != 0:
		_initialize()

func _initialize():
	for n in stats.starting_dice:
		spawn_die()
	_initialized = true

func spawn_die():
	var instance = _dice_obj.instantiate()
	instance.hide()
	add_child(instance)
	instance.dice = dice_stats.new()
	instance.dice.name = "diceRes_"+str(_spawnedDice)
	instance.dice.Initialize()
	instance.name = "Dice_"+str(_spawnedDice)
	_spawnedDice +=1
	var slot = tray.new_die()
	slot.place(instance)
	instance.global_position = slot.global_position
	instance._rest_point = slot
	instance.roll_dice_check()
	
func restart():
	for dice in get_tree().get_nodes_in_group("dice"):
		dice.queue_free()
	for zone in get_tree().get_nodes_in_group("zones"):
		zone.get_parent().queue_free()
	_initialize()

func refresh_dice():
	for dice in get_tree().get_nodes_in_group("dice"):
		dice.refresh_lockout()

func reset_positions():
	for dice in get_tree().get_nodes_in_group("dice"):
		dice.reset_position()