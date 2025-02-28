extends Control

@export var text_spot: RichLabelAutoSizer
@export var title_card_time: float
@export var title_card_time_boss: float
@export var click_block: Control

func _ready():
	signals.boss_fight.connect(_startBossFight)
	signals.show_title.connect(_displayTitleCard)

func _startBossFight(bossName: String):
	text_spot.text = bossName
	# text_spot.label_settings.font_color = Color.WHITE
	# text_spot.update_font_size()
	text_spot.z_index = 0
	click_block.show()
	await get_tree().create_timer(title_card_time_boss).timeout
	click_block.hide()
	text_spot.z_index = -1000
	signals.emit_boss_text_complete()

func _displayTitleCard(title:String, color: Color = Color.WHITE):
	text_spot.text = "[color=#%s]"%color.to_html() + title
	text_spot._check_line_count()
	# text_spot.update_font_size()
	# text_spot.label_settings.font_color = color
	text_spot.z_index = 0
	click_block.show()
	await get_tree().create_timer(title_card_time).timeout
	click_block.hide()
	text_spot.z_index = -1000
	signals.emit_title_complete()