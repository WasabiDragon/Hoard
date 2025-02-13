extends Node
class_name game_flow

var _currentLevel: level
var _currentLevelNum: int = 0
var _currentRound: round_info
var _currentRoundNum: int = 0
var _currentWave: int = 0
var _runningBossFight: bool = false
var _allSpawnComplete: bool = false

@export var upgrades: upgrades_panel
@export var game_over_screen: game_over_panel
@export var musicPlayer: music_player
@export var enemy_mgr: enemy_manager

@onready var levelList: level_list_class = %level_list
@onready var controller:= get_parent() as game_controller

func _ready():
	connect_signals()

func connect_signals():
	signals.check_round_end.connect(end_round_check)
	signals.next_round.connect(next_round)
	signals.turn_ended.connect(next_wave)
	signals.game_over.connect(game_over)
	signals.restarting.connect(restart)

func start_level():
	var got_level = levelList.levels[_currentLevelNum].duplicate()
	_currentLevel = got_level
	_currentRoundNum = 0
	start_round()

func start_round():
	_currentWave = 0
	_update_round_tracker()
	if _runningBossFight:
		signals.emit_boss_fight(_currentRound.boss_round_name)
		await signals.boss_text_complete
	signals.emit_refresh_all()
	signals.emit_roll_dice()
	next_wave()
	
func end_round_check():
	await get_tree().create_timer(0.5).timeout
	if _allSpawnComplete && enemy_mgr.livingEnemies <= 0:
		_end_round()

func end_level():
	if _currentLevelNum +1 >= levelList.levels.size():
		victory()
		return
	open_upgrades()
	_currentLevelNum += 1
	# start_level()

func _end_round():
	if _currentRound.has_boss && !_runningBossFight:
		_runningBossFight = true
		start_level()
		return
	if _currentRoundNum +1 >= _currentLevel.rounds.size() && !_runningBossFight:
		end_level()
		return
	open_upgrades()
	_currentRoundNum += 1

func next_round():
	start_round()

func open_upgrades():
	upgrades.visible = true
	if _runningBossFight:
		upgrades.set_boss_choices()
		_runningBossFight = false
	else:		
		upgrades.set_choices()

func victory():
	game_over_screen.victory()
	game_over_screen.show()

func game_over():
	musicPlayer.play_game_over()
	
func restart():
	_currentLevel = level.new()
	_currentLevelNum = 0
	_currentRoundNum = 0
	_allSpawnComplete = false
	_runningBossFight = false

func _update_round_tracker():
	var target_round = _currentLevel.rounds[_currentRoundNum].duplicate() if !_runningBossFight else _currentLevel.rounds[_currentRoundNum].boss[randi() % _currentLevel.rounds[_currentRoundNum].boss.size()].duplicate()
	_currentRound = target_round

func next_wave():
	enemy_mgr.update_enemies()
	if _currentRound.is_wave_in_round(_currentWave):
		enemy_mgr.spawn_enemies(_currentWave, _currentRound)
	if !_currentRound.is_wave_in_round(_currentWave+1):
		_allSpawnComplete = true
	_currentWave += 1