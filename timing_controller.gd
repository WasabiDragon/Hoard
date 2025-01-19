extends Node
class_name timing_controller

var _dice = []
@export var diceSpeed: float
@export var enemySpeed: float
@export var upgrades: upgrades_panel
@export var game_over_screen: game_over_panel
@export var _dice_spawner: dice_spawner
@export var musicPlayer: music_player
var _spawner: spawner
var _currentLevel: enemy_info_list
var _currentLevelNum: int = 0
var levelList: level_list_class
var _infoTracker: enemy_info = enemy_info.new()
var _infoCurrentIndex: int = 0
var _spawning = false
var _allSpawnComplete = false
var _dam_calc: damage_calc

# Called when the node enters the scene tree for the first time.
func _ready():
	_dice = get_tree().get_nodes_in_group("dice")
	_currentLevel = enemy_info_list.new()
	_spawner = %enemy_spawner
	levelList = %level_list
	_dam_calc = %damage_calculator

func start_game():
	musicPlayer.play_game_music()
	_start_level()

func next_level():
	_start_level()

func _start_level():
	var level = levelList.level_list[_currentLevelNum].duplicate()
	_currentLevel = level
	_infoCurrentIndex = 0
	_allSpawnComplete = false
	_dice_spawner.refresh_dice()
	_update_info_tracker()
	_roll_all_dice()

func _end_turn():
	_roll_all_dice()
	_update_enemies()
	if damage_calc == null:
		_dam_calc = %damage_calculator
	_dam_calc.apply_burns()

func end_level_check():
	await get_tree().create_timer(0.5).timeout
	if _allSpawnComplete && _spawner.spawn_parent.get_children().size() <= 0:
		_end_level()

func _end_level():
	if levelList.level_list.size() <= _currentLevelNum +1:
		victory()
		return
	upgrades.visible = true
	_currentLevel = enemy_info_list.new()
	upgrades.set_choices()
	_currentLevelNum +=1

func _roll_all_dice():
	_dice = get_tree().get_nodes_in_group("dice")
	for dice in _dice:
		dice.roll_dice_check()

func _update_enemies():
	_move_enemies()
	if _infoTracker != null:
		_infoTracker.timeToWait -= 1
	if(!_allSpawnComplete && !_spawning && _infoTracker.timeToWait <= 0):
		_spawning = true
		_update_info_tracker()

func _update_info_tracker():
	_infoTracker = _currentLevel.info_list[_infoCurrentIndex].duplicate() if _currentLevel.info_list.size() > _infoCurrentIndex else null
	_infoCurrentIndex +=1
	spawn_enemies()
	if _currentLevel.info_list.size() <= _infoCurrentIndex:
		_allSpawnComplete = true;

func spawn_enemies():
	var _spawnedLocations = []
	for n in _infoTracker.enemies:
		_spawnedLocations.append(_spawner.spawn_enemy(_spawnedLocations))
	for n in _infoTracker.bosses:
		_spawnedLocations.append(_spawner.spawn_boss(_spawnedLocations))
	_spawning = false

func _move_enemies():
	_spawner._move_enemies()

func check_game_over():
	for target in _spawner.spawn_parent.get_children():
		if target.global_position.y > _spawner.dead_line.global_position.y:
			game_over()

func game_over():
	musicPlayer.play_game_over()
	game_over_screen.show()
	

func restart():
	_currentLevel = enemy_info_list.new()
	_currentLevelNum = 0
	_infoCurrentIndex = 0
	_allSpawnComplete = false
	_spawner.restart()
	_dice_spawner.restart()
	start_game()

func victory():
	game_over_screen.victory()
	game_over_screen.show()