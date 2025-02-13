extends MarginContainer
class_name upgrades_panel

## upgrade = 0, role = 1, extra dice = 2
@export var panels: Array[Button]

@export var dice_upgrade_image: Texture2D
@export var extra_die_image: Texture2D
@export var drops: upgrade_drop
@export var endTurnButton: Control
@export var role_mgr: role_manager
var _current_role: dice_stats.diceRole
@onready var _audio = $upgradeSound as audio_bank
var _boss_upgrade_choices
var bossChoice = false

func _ready():
	panels[0].pressed.connect(_click_panel_0)
	panels[1].pressed.connect(_click_panel_1)
	panels[2].pressed.connect(_click_panel_2)

func set_choices():
	bossChoice = false
	endTurnButton.hide()
	set_dice_panel()
	set_role_panel()
	set_upgrade_panel()
	_audio.play_from_list()

func set_boss_choices():
	bossChoice = true
	endTurnButton.hide()
	_audio.play_from_list()
	_boss_upgrade_choices = []
	var roles_to_upgrade = dice_stats.diceRole.keys()
	roles_to_upgrade.erase("Cowboy")
	for die in get_tree().get_nodes_in_group("dice"):
		print(die.dice.role)
		if die.dice.role != dice_stats.diceRole.Cowboy:
			roles_to_upgrade.append(die.dice.role)
	for panel in panels:
		var choice = roles_to_upgrade.pop_at(randi() % roles_to_upgrade.size())
		panel.text_box.text = "[center]Upgrade [color=#%s]%s[/color]" %[role_mgr.get_role_color(dice_stats.diceRole[choice]).to_html(false), choice] +"\n"+ role_mgr.get_upgrade_text(dice_stats.diceRole[choice])
		panel.image_box.texture = role_mgr.get_role_image(dice_stats.diceRole[choice])
		_boss_upgrade_choices.append(dice_stats.diceRole[choice])
	
func set_role_panel():
	var roles = dice_stats.diceRole.values()
	roles.erase(dice_stats.diceRole.Cowboy)
	_current_role = dice_stats.diceRole[dice_stats.diceRole.keys()[roles[randi() % roles.size()]]]
	var output_text = "[center]Set a dice to a new role. \n"
	output_text += role_mgr.get_role_text(_current_role)
	panels[1].text_box.text = output_text
	panels[1].image_box.texture = role_mgr.get_role_image(_current_role)

func set_dice_panel():
	if get_tree().get_nodes_in_group("dice").size() >= stats.max_dice:
		panels[2].visible = false
	else:
		panels[2].image_box.texture = extra_die_image
		panels[2].text_box.text = "Gain an additional dice."

func set_upgrade_panel():
	panels[0].image_box.texture = dice_upgrade_image
	panels[0].text_box.text = "Transform a dice to the next tier."

func select_role():
	drops.drop_dice_class(panels[1].image_box.texture, _current_role)
	close_panel()	

func select_upgrade():
	drops.drop_upgrade(panels[0].image_box.texture)
	close_panel()

func select_extra_dice():
	drops.drop_extra_dice()
	close_panel()

func close_panel():
	hide()

func _click_panel_0():
	select_panel(0)

func _click_panel_1():
	select_panel(1)

func _click_panel_2():
	select_panel(2)

func select_panel(panelNumber):
	var nonBossPanelFuncs: Array[Callable] = [select_upgrade, select_role, select_extra_dice]
	if !bossChoice:
		nonBossPanelFuncs[panelNumber].call()
	else:
		role_mgr.upgrade_role(_boss_upgrade_choices[panelNumber])
		_boss_upgrade_choices = []
		drops.boss_upgrade()
		close_panel()