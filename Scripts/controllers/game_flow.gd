extends Node
class_name game_flow

var _currentLevel: level
var _currentLevelNum: int = 0
var _currentRound: round_info
var _currentRoundNum: int = 0
var _currentWave: int = 0
enum bossFightState {INACTIVE, ACTIVE, COMPLETE}
var _boss: bossFightState = bossFightState.INACTIVE
var _end_round_check_in_progress: bool
var _game_over = false

enum flowState {GAME, LEVEL, ROUND, WAVE}
enum levelSelectState{SELECTING, COMPLETE}

signal levelSelectComplete
var levelSelect: levelSelectState:
	get:
		return levelSelect
	set(value):
		levelSelect = value
		if value == levelSelectState.COMPLETE:
			levelSelectComplete.emit()

var _allSpawnComplete: bool = false

@export var upgrades: upgrades_panel
@export var game_over_screen: game_over_panel
@export var musicPlayer: music_player
@export var enemy_mgr: enemy_manager
@export var next_round_button: Button
@export var end_turn_button: TextureButton
@export var debug_lvl_num: Label

@onready var map_mgr:= %map_manager
@onready var levelList:= %level_list
@onready var controller:= get_parent() as game_controller

func _ready():
	connect_signals()

func connect_signals():
	signals.check_round_end.connect(end_round_check)
	signals.next_round.connect(next_round)
	signals.turn_ended.connect(next_wave)
	signals.game_over.connect(game_over)
	signals.restarting.connect(restart)

func map_select():
	globals.game_running = false
	if !map_mgr.create_next_map(_currentLevelNum):
		print("Opening endscreen")
		victory()
	await signals.map_option_selected
	next(flowState.LEVEL)

func start_level():
	map_select()
	

func start_round():
	await display_titles()
	end_turn_button.get_parent().show()
	signals.emit_refresh_all()
	signals.emit_roll_dice()
	next_wave()

func end_round_check():
	if _end_round_check_in_progress:
		return
	else:
		_end_round_check_in_progress = true
	await get_tree().create_timer(0.5).timeout
	if _allSpawnComplete && enemy_mgr.livingEnemies <= 0:
		print('round endedchecking for round end')
		signals.emit_refresh_all()
		_end_round()
	_end_round_check_in_progress = false

func end_level():
	if _currentLevelNum +1 > globals.max_levels:
		victory()
		return
	_currentLevelNum += 1
	map_select()

func _end_round():
	if !_game_over:
		open_upgrades()

func next_round():
	next(flowState.ROUND)

func next_wave():
	enemy_mgr.update_enemies()
	if globals.consumable_freeze_toggle:
		return
	if _currentRound.is_wave_in_round(_currentWave):
		enemy_mgr.spawn_enemies(_currentWave, _currentRound)
	if !_currentRound.is_wave_in_round(_currentWave+1):
		_allSpawnComplete = true
	_currentWave += 1
	debug_lvl_num.text = str("lvl: %d, round: %d, wave: %d"%[_currentLevelNum+1, _currentRoundNum+1, _currentWave])

func get_remaining_waves() -> int:
	return _currentRound.get_wave_count()

func open_upgrades():
	if _boss == bossFightState.ACTIVE:
		globals.game_running = false
		signals.emit_boss_complete()
		upgrades.boss_upgrade(_currentRound.boss_reward)
		_boss = bossFightState.COMPLETE
	elif _currentRound.has_rewards:		
		globals.game_running = false
		upgrades.set_choices(rewards.generate_standard_rewards())
	else:
		signals.emit_next_round()

func _get_next_round():
	if _boss == bossFightState.ACTIVE:
		_currentRound = _currentLevel.rounds[_currentRoundNum].boss.duplicate()
	else:
		_currentRound = _currentLevel.rounds[_currentRoundNum].duplicate()
	debug_lvl_num.text = str("lvl: %d, round: %d, wave: %d"%[_currentLevelNum+1, _currentRoundNum+1, _currentWave])

func victory():
	game_over_screen.victory()
	game_over_screen.show()

func game_over():
	_game_over = true
	musicPlayer.play_game_over()
	
func restart():
	end_turn_button.get_parent().hide()
	next(flowState.GAME)

func display_titles() -> void:
	if _boss == bossFightState.ACTIVE:
		signals.emit_boss_fight(_currentRound.boss_round_name)
		await signals.boss_text_complete
		return
	else:
		var text_color
		if _currentRound.has_rewards:
			text_color = Color.GOLD
		elif _currentRound.has_boss:
			text_color = Color.RED
		else:
			text_color = Color.WHITE
		signals.emit_show_title(str(_currentRoundNum+1), text_color)
		await signals.title_complete
		return

func next(state: flowState)-> void:
	match state:
		flowState.GAME:
			_currentLevel = level.new()
			_currentLevelNum = 0
			_currentRoundNum = 0
			_allSpawnComplete = false
			_game_over = false
			_boss = bossFightState.INACTIVE
		flowState.LEVEL:
			_currentLevel = levelList.levels[_currentLevelNum].duplicate()
			_currentRoundNum = 0
			_allSpawnComplete = false
			_boss = bossFightState.INACTIVE
			_get_next_round()
			next(flowState.ROUND)
		flowState.ROUND:
			match _boss:
				bossFightState.INACTIVE:
					if _currentRound.has_boss && _currentLevel.rounds.size() <= _currentRoundNum:
						_boss = bossFightState.ACTIVE
						_currentRoundNum -=1
				bossFightState.ACTIVE:
					print("Should not return next when boss is active")
					pass
				bossFightState.COMPLETE:
					end_level()
					return
			globals.game_running = true
			_currentWave = 0
			_allSpawnComplete = false
			_get_next_round()
			start_round()
			if globals.debug_enabled: 
				var debug_difficulty_announce:= 0
				for n in _currentRound.challenge_rating:
					debug_difficulty_announce += n
				print(debug_difficulty_announce)
			_currentRoundNum +=1
		flowState.WAVE:
			pass