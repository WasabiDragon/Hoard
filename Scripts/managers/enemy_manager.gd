extends Node
class_name enemy_manager

# var _allSpawnComplete:= false
var _spawning:= false
var _movementEnabled:= true

@export var _spawner: spawner

var livingEnemies:
	get:
		return _spawner.spawn_parent.get_children().size()

@onready var controller:= get_parent() as game_controller

func _ready():
	connect_signals()

func connect_signals():
	signals.refresh_all.connect(_reset)
	signals.restarting.connect(_reset)
	signals.game_over.connect(_disable_movement)

func update_enemies():
	_move_enemies()

func spawn_enemies(currentWave: int, roundData: round_info):
	var wave_to_spawn = roundData.get_wave(currentWave)
	_spawner.spawn_enemies(wave_to_spawn)
	_spawning = false

func _move_enemies():
	if !_movementEnabled:
		return
	_spawner._move_enemies()

func _reset():
	_movementEnabled = true

func _disable_movement():
	_movementEnabled = false
