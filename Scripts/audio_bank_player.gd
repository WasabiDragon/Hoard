extends AudioStreamPlayer
class_name audio_bank

@export var sounds: Array[AudioStream]
enum audio_type{
	SFX,
	Music
}
@export var type: audio_type

func _ready():
	if type == audio_type.SFX:
		signals.sfx_volume_changed.connect(change_volume)
	if type == audio_type.Music:
		signals.music_volume_changed.connect(change_volume)

func play_from_list():
	var _toPlay = sounds[randi() % sounds.size()]
	stream = _toPlay
	change_volume()
	play()

func change_volume():
	if type == audio_type.SFX:
		volume_linear = stats.sfx_volume
	if type == audio_type.Music:
		volume_linear = stats.music_volume * stats.max_music_volume