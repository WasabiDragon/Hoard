extends Node
class_name timing_controller

var _dice = []
@export var diceSpeed: float
@export var enemySpeed: float
var _spawner: spawner
var _currentLevel: enemy_info_list
var _currentLevelNum: int = 0
var levelList: level_list
var _runningLevel: bool = false
var _infoTracker: enemy_info = enemy_info.new()
var _infoCurrentIndex: int = 0
var _spawning = false
var _allSpawnComplete = false

# Called when the node enters the scene tree for the first time.
func _ready():
	_dice = get_tree().get_nodes_in_group("dice")
	_spawner = %enemy_spawner
	levelList = %level_list


func start_game():
	_start_level()

func _start_level():
	if _currentLevel == null:
		_currentLevel = levelList.level_list[_currentLevelNum]
	_update_info_tracker()
	_roll_all_dice()
	_runningLevel = true

func _end_turn():
	_roll_all_dice()
	_update_enemies()


func _roll_all_dice():
	_dice = get_tree().get_nodes_in_group("dice")
	for dice in _dice:
		dice.rollDice()

func _update_enemies():
	_move_enemies()
	if _infoTracker != null:
		_infoTracker.timeToWait -= 1
	if(!_allSpawnComplete && !_spawning && _infoTracker.timeToWait <= 0):
		_spawning = true
		_update_info_tracker()

func _update_info_tracker():
	_infoTracker = _currentLevel.info_list[_infoCurrentIndex] if _currentLevel.info_list.size() > _infoCurrentIndex else null
	_infoCurrentIndex +=1
	var _spawnedLocations = []
	if(_infoTracker == null):
		_allSpawnComplete = true
		_spawning = false
		return
	for n in _infoTracker.enemies:
		_spawnedLocations.append(_spawner.spawn_enemy(_spawnedLocations))
	for n in _infoTracker.bosses:
		_spawnedLocations.append(_spawner.spawn_boss(_spawnedLocations))
	_spawning = false

func _move_enemies():
	_spawner._move_enemies()