extends AudioStreamPlayer
class_name music_player

@export var debug_mute_all:= false
@export var fade_speed: float = 8
@export var gameMusicList: Array[AudioStream]
@export var menuMusicList: Array[AudioStream]
@export var gameOverMusicList: Array[AudioStream]
@export var bossMusicList: Array[AudioStream]
var _lastPlayed: AudioStream
var _game:bool = false
var _menu:bool = false
var _gameOver: bool = false
var _boss: bool = false
var fade:bool = false
var fade_target:float
var initialized:bool = false

signal fade_complete

func _ready():
	connect_signals()
	play_menu_music()

func connect_signals():
	finished.connect(play_next)
	signals.game_over.connect(play_game_over)
	signals.game_start.connect(play_game_music)
	signals.music_menus.connect(play_menu_music)
	signals.boss_fight.connect(play_boss_music)
	signals.boss_complete.connect(play_game_music)
	signals.music_volume_changed.connect(change_volume)

func _process(delta):
	if fade:
		var target_vol = float(lerp(volume_linear, fade_target, fade_speed*delta))
		volume_linear = target_vol if target_vol >=0 else 0.0
		if abs(volume_linear - fade_target) <= 0.01:
			fade = false
			fade_complete.emit()

func _fade(target_vol: float):
	fade_target = target_vol
	fade = true

func random_song_from_playlist(playlist: Array[AudioStream], repeats: bool = false):
	if !initialized:
		await signals.audio_setup_complete
		initialized = true
	var _randomList = playlist.duplicate()
	if !repeats && _lastPlayed != null && _randomList.size() > 1:
		_randomList.erase(_lastPlayed)
	var _nextSong: AudioStream = playlist[playlist.find(_randomList[randi() % (_randomList.size())])]
	if !playing:
		volume_linear = 0
	else:
		_fade(0.0)
		await fade_complete
	stream = _nextSong
	play()
	_fade(stats.music_volume * stats.max_music_volume)
	_lastPlayed = _nextSong

func play_game_music():
	if debug_mute_all:
		return
	_game = true
	_menu = false
	_gameOver = false
	_boss = false
	random_song_from_playlist(gameMusicList)

func play_menu_music():
	if debug_mute_all:
		return
	_game = false
	_menu = true
	_gameOver = false
	_boss = false
	random_song_from_playlist(menuMusicList, true)

func play_game_over():
	if debug_mute_all:
		return
	_boss = false
	_game = true
	_menu = false
	_gameOver = false
	random_song_from_playlist(gameOverMusicList)

func play_boss_music(_discard):
	if debug_mute_all:
		return
	_boss = true
	_game = false
	_menu = false
	_gameOver = false
	random_song_from_playlist(bossMusicList)


func play_next():
	if debug_mute_all:
		return
	if _game:
		play_game_music()
	elif _menu:
		play_menu_music()
	elif _boss:
		play_boss_music(null)

func change_volume():
	volume_linear = stats.music_volume * stats.max_music_volume