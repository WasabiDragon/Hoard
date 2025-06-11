extends Node
class_name audio_manager

@export_range(0,100) var default_music_val: float
@export_range(0,100) var max_music_val: float
@export_range(0,100) var default_sfx_val: float

func _ready():
	globals.max_music_volume = max_music_val
	globals.music_volume = default_music_val
	globals.sfx_volume = default_sfx_val
	signals.emit_audio_setup_complete()
