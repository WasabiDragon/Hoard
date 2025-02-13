extends Control

@export var text_spot: AutoSizeLabel
@export var title_card_time: float

func _ready():
	signals.boss_fight.connect(_startBossFight)

func _startBossFight(bossName: String):
	text_spot.text = bossName
	show()
	await get_tree().create_timer(title_card_time).timeout
	hide()
	signals.emit_boss_text_complete()