extends Control
class_name map_option

var levelObject: level
var reward: reward_obj
@export var select_overlay: ColorRect
@export var boss_label: RichLabelAutoSizer
@export var waves_label: RichLabelAutoSizer
@export var reward_texture: TextureRect
@export var c_tooltip: custom_tooltip

@onready var role_mgr: role_manager = $/root/Main/game_controller/role_manager

func _gui_input(event):
	if event.is_action("click") && is_visible_in_tree():
		print("Option clicked: %s"%[str(reward_obj.reward.keys()[reward.type])])
		signals.emit_map_option_selected(levelObject)
	
func set_level(levelObj: level):
	levelObject = levelObj
	reward = levelObj.rounds[-1].boss.boss_reward
	waves_label.text = str(levelObj.rounds.size())
	set_tooltip()
	
func set_image(texture: Texture2D):
	reward_texture.texture = texture

func set_boss_name(bossName: String):
	boss_label.text = bossName
	boss_label._size_just_modified_by_autosizer = true
	set_tooltip()

func enable_overlay():
	select_overlay.show()

func disable_overlay():
	select_overlay.hide()

func select():
	signals.emit_map_option_selected(levelObject)

func set_tooltip():
	var c_tooltip_text:String = "[font_size=32][b]Boss:[/b] %s\n[b]Waves:[/b]%s[/font_size]\n\n[font_size=28]"%[str(boss_label.text).to_lower(),waves_label.text,]
	match reward.type:
		reward_obj.reward.DIE:
			c_tooltip_text += "[b]Extra Die:[/b]\nGain an additional die."
		reward_obj.reward.ROLE:
			c_tooltip_text += "[b]Upgrade [color=#%s]%s[/color][/b]:" %[role_mgr.get_role_color(reward.role).to_html(false), dice_stats.diceRole.keys()[reward.role]] +"\n"+ role_mgr.get_upgrade_text(reward.role)
		reward_obj.reward.CONSUMABLE:
			c_tooltip_text += "[b]Consumable: [/b]" + reward.consumable_reward.description
	c_tooltip.update_tooltip(c_tooltip_text)