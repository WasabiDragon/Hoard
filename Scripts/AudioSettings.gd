extends Node
class_name audio_settings

@export var slider: Slider
@export var percent: Label
enum audio_type{
	SFX,
	Music
}
@export var type: audio_type

var changing = false

func _ready():
	slider.drag_started.connect(start_change)
	slider.drag_ended.connect(end_change)

func start_change():
	changing = true

func end_change(_val):
	changing = false

func _process(_delta):
	if changing:
		set_stats()

func set_stats():
	if type == audio_type.SFX:
		stats.sfx_volume = slider.value
	if type == audio_type.Music:
		stats.music_volume = slider.value
	percent.text = str(roundi(slider.value)) + "%"

func _on_draw():
	print("updating")
	if type == audio_type.SFX:
		slider.value = stats.sfx_volume * 100
	if type == audio_type.Music:
		slider.value = stats.music_volume * 100
	percent.text = str(roundi(slider.value)) + "%"

