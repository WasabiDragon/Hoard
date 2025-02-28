extends MarginContainer
class_name upgrades_panel

## upgrade = 0, role = 1, extra dice = 2
@export var panels: Array[Button]

@export var dice_upgrade_image: Texture2D
@export var extra_die_image: Texture2D
@export var drops: upgrade_drop
@export var endTurnButton: Control
@export var role_mgr: role_manager
var _current_roles: Array
@export var _audio: audio_bank
var _boss_upgrade_choice: Array
var bossChoice = false

func _ready():
	panels[0].pressed.connect(_click_panel_0)
	panels[1].pressed.connect(_click_panel_1)
	panels[2].pressed.connect(_click_panel_2)

func set_choices():
	bossChoice = false
	endTurnButton.hide()
	_current_roles = []
	set_role_panels()
	set_upgrade_panel(panels[2])
	_audio.play_from_list()

func set_boss_choices():
	bossChoice = true
	endTurnButton.hide()
	_audio.play_from_list()
	_boss_upgrade_choice = []
	set_dice_panel(panels[0])
	set_boss_upgrade_panels([panels[1],panels[2]])
		
func set_boss_upgrade_panels(targetPanels: Array) -> void:
	var roles_to_upgrade = []
	roles_to_upgrade = _select_available_boss_upgrade_roles()
	for panel in targetPanels:
		panel.hide()
	if !roles_to_upgrade.is_empty():
		targetPanels[0].show()
		var choice = roles_to_upgrade.pop_at(randi() % roles_to_upgrade.size())
		_display_boss_upgrade(targetPanels[0],choice)
		targetPanels[0].boss_upgrade_num = 0		
		if roles_to_upgrade.size() > 1:
			targetPanels[1].show()
			var second_choice = roles_to_upgrade.pop_at(randi()%roles_to_upgrade.size())
			_display_boss_upgrade(targetPanels[1],second_choice)
			targetPanels[1].boss_upgrade_num = 1

func _display_boss_upgrade(panel: Button, role: dice_stats.diceRole):
	panel.text_box.text = "[center]Upgrade [color=#%s]%s[/color]" %[role_mgr.get_role_color(role).to_html(false), dice_stats.diceRole.keys()[role]] +"\n"+ role_mgr.get_upgrade_text(role)
	panel.image_box.texture = role_mgr.get_role_image(role)
	_boss_upgrade_choice.append(role)

func _select_available_boss_upgrade_roles() -> Array:
	var roles_to_upgrade = []
	for die in get_tree().get_nodes_in_group("dice"):
		if die.dice.role != dice_stats.diceRole.Cowboy:
			roles_to_upgrade.append(die.dice.role)
	return roles_to_upgrade
	
func set_role_panels():
	var roles = dice_stats.diceRole.keys()
	roles.erase(dice_stats.diceRole.keys()[dice_stats.diceRole.Cowboy])
	_current_roles.append(roles.pop_at(randi() % roles.size()))
	_current_roles.append(roles.pop_at(randi() % roles.size()))
	_set_role_panel(panels[0], dice_stats.diceRole[_current_roles[0]])
	_set_role_panel(panels[1], dice_stats.diceRole[_current_roles[1]])

func _set_role_panel(panel: Button, role: dice_stats.diceRole):
	var roles = dice_stats.diceRole.values()
	roles.erase(dice_stats.diceRole.Cowboy)
	var output_text = "[center]Set a dice to a new role. \n"
	output_text += role_mgr.get_role_text(role)
	panel.text_box.text = output_text
	panel.image_box.texture = role_mgr.get_role_image(role)
	panel.button_type = upgrade_box.button_job.role

func set_dice_panel(panel: Button):
	if get_tree().get_nodes_in_group("dice").size() >= stats.max_dice:
		panel.visible = false
	else:
		panel.image_box.texture = extra_die_image
		panel.text_box.text = "[center]Gain an additional dice."
		panel.button_type = upgrade_box.button_job.extra

func set_upgrade_panel(panel: Button):
	panel.image_box.texture = dice_upgrade_image
	panel.text_box.text = "[center]Add one upgrade point to one of your dice."
	panel.button_type = upgrade_box.button_job.upgrade

func select_role(panel: Button):
	drops.drop_dice_class(panel.image_box.texture, dice_stats.diceRole[_current_roles[panels.find(panel)]])
	close_panel()	

func select_upgrade(panel: Button):
	drops.drop_upgrade(panel.image_box.texture)
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
	var button_type = panels[panelNumber].button_type
	if button_type == upgrade_box.button_job.upgrade:
		select_upgrade(panels[panelNumber])
	if button_type == upgrade_box.button_job.role:
		select_role(panels[panelNumber])
	if button_type == upgrade_box.button_job.extra:
		select_extra_dice()
	if button_type == upgrade_box.button_job.boss:
		role_mgr.upgrade_role(_boss_upgrade_choice[panels[panelNumber].boss_upgrade_num])
