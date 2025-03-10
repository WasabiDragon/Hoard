extends Control
class_name map_option

var levelObject: level
var reward: reward_obj
@export var select_overlay: ColorRect
@export var boss_label: RichLabelAutoSizer
@export var waves_label: RichLabelAutoSizer
@export var reward_texture: TextureRect

func _gui_input(event):
	if event.is_action("click") && is_visible_in_tree():
		print("Option clicked: %s"%[str(reward_obj.reward.keys()[reward.type])])
		signals.emit_map_option_selected(levelObject)
	
func set_level(levelObj: level):
	levelObject = levelObj
	reward = levelObj.rounds[-1].boss.reward
	waves_label.text = str(levelObj.rounds.size())
	
func set_image(texture: Texture2D):
	reward_texture.texture = texture

func set_boss_name(bossName: String):
	boss_label.text = bossName
	boss_label._size_just_modified_by_autosizer = true

func enable_overlay():
	select_overlay.show()

func disable_overlay():
	select_overlay.hide()

func select():
	signals.emit_map_option_selected(levelObject)