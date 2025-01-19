extends MarginContainer
class_name upgrades_panel

@export var upgrade_panel: Button
@export var role_panel: Button
@export var extra_die_panel: Button
@export var all_images: upgrade_images
@export var drops: upgrade_drop
var _current_role: dice_stats.diceClass
@onready var _audio = $upgradeSound as audio_bank

func _ready():
	upgrade_panel.pressed.connect(select_upgrade)
	role_panel.pressed.connect(select_role)
	extra_die_panel.pressed.connect(select_extra_dice)

func set_choices():
	set_dice_panel()
	set_role_panel()
	set_upgrade_panel()
	_audio.play_from_list()
	
func set_role_panel():
	_current_role = dice_stats.diceClass[dice_stats.diceClass.keys()[randi() % (dice_stats.diceClass.size()-1)]]
	var output_text = "Set a dice to a new role. \n"
	match _current_role:
		dice_stats.diceClass.Rogue:
			output_text += "Rogue: 30%% chance of dealing double damage."
		dice_stats.diceClass.Wizard:
			output_text += "Wizard: Hits all adjacent targets too."
		dice_stats.diceClass.Warrior:
			output_text += "Warrior: Hits twice in the same turn."
		dice_stats.diceClass.Alchemist:
			output_text += "Alchemist: Burns the target for 2 additional turns."
		dice_stats.diceClass.Medic:
			output_text += "Healer: Reduces the lockout period of one other dice."
		dice_stats.diceClass.Holy:
			output_text += "Priest: Recovers lockout faster than other dice."
		_:
			output_text += "Failed to find class"
	role_panel.text_box.text = output_text

	for bundle in all_images.images:
		if bundle.role == _current_role:
			role_panel.image_box.texture = bundle.image

func set_dice_panel():
	if get_tree().get_nodes_in_group("dice").size() >= 5:
		extra_die_panel.visible = false
	else:
		var die_image = null
		for bundle in all_images.images:
			if bundle.type == droppable_upgrade.upgradeType.extraDie:
				die_image = bundle.image
		extra_die_panel.image_box.texture = die_image
		extra_die_panel.text_box.text = "Gain an additional dice. Place on an empty slot."

func set_upgrade_panel():
	var upgrade_image_setter = null
	for bundle in all_images.images:
		if bundle.type == droppable_upgrade.upgradeType.upgrade:
			upgrade_image_setter = bundle.image
	upgrade_panel.image_box.texture = upgrade_image_setter
	upgrade_panel.text_box.text = "Transform a dice to the next tier."

func select_role():
	drops.drop_dice_class(role_panel.image_box.texture, _current_role)
	close_panel()	

func select_upgrade():
	drops.drop_upgrade(upgrade_panel.image_box.texture)
	close_panel()

func select_extra_dice():
	drops.drop_extra_dice(extra_die_panel.image_box.texture)
	close_panel()

func close_panel():
	hide()
