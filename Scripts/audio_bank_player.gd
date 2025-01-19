extends AudioStreamPlayer
class_name audio_bank

@export var sounds: Array[AudioStream]

func play_from_list():
	var _toPlay = sounds[randi() % sounds.size()]
	stream = _toPlay
	play()