extends AudioStreamPlayer
class_name music_player

@export var debug_mute_all:= false
@export var gameMusicList: Array[AudioStream]
@export var menuMusicList: Array[AudioStream]
@export var gameOverMusicList: Array[AudioStream]
var _lastPlayed: AudioStream
var _game:bool = false
var _menu:bool = false
var _gameOver: bool = false

func _ready():
	finished.connect(play_next)
	play_menu_music()
	connect_signals()

func connect_signals():
	signals.music_game_over.connect(play_game_over)
	signals.music_game_start.connect(play_game_music)
	signals.music_menus.connect(play_menu_music)

func random_song_from_playlist(playlist: Array[AudioStream], repeats: bool = false):
	var _randomList = playlist.duplicate()
	if !repeats && _lastPlayed != null:
		_randomList.erase(_lastPlayed)
	var _nextSong: AudioStream = playlist[playlist.find(_randomList[randi() % (_randomList.size())])]
	stream = _nextSong
	play()
	_lastPlayed = _nextSong

func play_game_music():
	if debug_mute_all:
		return
	_game = true
	_menu = false
	_gameOver = false
	random_song_from_playlist(gameMusicList)

func play_menu_music():
	if debug_mute_all:
		return
	_game = false
	_menu = true
	_gameOver = false
	random_song_from_playlist(menuMusicList, true)

func play_game_over():
	if debug_mute_all:
		return
	_game = true
	_menu = false
	_gameOver = false
	random_song_from_playlist(gameOverMusicList)

func play_next():
	if debug_mute_all:
		return
	if _game:
		play_game_music()
	elif _menu:
		play_menu_music()