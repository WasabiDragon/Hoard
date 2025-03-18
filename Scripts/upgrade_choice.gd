extends MarginContainer
class_name upgrades_panel

## upgrade = 0, role = 1, extra dice = 2
@export var panels: Array[Button]

@export var dice_upgrade_image: Texture2D
@export var extra_die_image: Texture2D
# @export var drops: upgrade_drop
@export var dice_upgrade_display: dice_upgrade_display_panel
@export var endTurnButton: Control
@export var role_mgr: role_manager
@export var boss_upgrade_panel: boss_upgrade_screen
@export var _audio: audio_bank
@export var general_upgrade_panel: Control
@export var acceptButton: Button

var _current_roles: Array
var _boss_upgrade_choice: Array
var bossChoice = false

func _ready():
	get_viewport().gui_focus_changed.connect(_on_focus_changed)

func set_choices(rewardSet: Array[reward_obj]):
	var panelNumber = 0
	bossChoice = false
	_current_roles = []
	for reward in rewardSet:
		match reward.type:
			reward_obj.reward.ROLE:
				_set_role_panel(panels[panelNumber], reward.role)
				_current_roles.append(reward.role)
			reward_obj.reward.TIER_UP:
				set_upgrade_panel(panels[panelNumber])
				_current_roles.append(null)
		panels[panelNumber].show()
		panels[panelNumber].set_panel_num(panelNumber+1)
		panelNumber +=1
	general_upgrade_panel.show()
	acceptButton.disabled = true
	endTurnButton.hide()
	_audio.play_from_list()

func boss_upgrade(reward: reward_obj):
	print("setting boss upgrades")
	endTurnButton.hide()
	_audio.play_from_list()
	var display_text: String
	var display_img: Texture2D
	if reward.type == reward_obj.reward.DIE:
		display_img = extra_die_image
		display_text = "[center]You have gained an extra die."
		dice_upgrade_display.drop_extra_dice()
		boss_upgrade_panel.display_boss_upgrade(display_img,display_text)
		await boss_upgrade_panel.boss_upgrade_display_complete
	elif reward.type == reward_obj.reward.ROLE:
		display_img = role_mgr.get_role_image(reward.role)
		display_text = "[center]Upgrade [color=#%s]%s[/color]" %[role_mgr.get_role_color(reward.role).to_html(false), dice_stats.diceRole.keys()[reward.role]] +"\n"+ role_mgr.get_upgrade_text(reward.role)
		role_mgr.upgrade_role(reward.role)
		boss_upgrade_panel.display_boss_upgrade(display_img,display_text)
		await boss_upgrade_panel.boss_upgrade_display_complete
	elif reward.type == reward_obj.reward.CONSUMABLE:
		display_img = reward.consumable_reward.image
		display_text = reward.consumable_reward.description
		boss_upgrade_panel.display_boss_upgrade(display_img,display_text)
		await boss_upgrade_panel.boss_upgrade_display_complete
		signals.emit_add_consumable(reward.consumable_reward)
	dice_upgrade_display.upgrade_complete()

func _select_available_boss_upgrade_roles() -> Array:
	var roles_to_upgrade = []
	for die in get_tree().get_nodes_in_group("dice"):
		if die.dice.role != dice_stats.diceRole.Cowboy:
			roles_to_upgrade.append(die.dice.role)
	return roles_to_upgrade


func _set_role_panel(panel: Button, role: dice_stats.diceRole):
	var roles = dice_stats.diceRole.values()
	roles.erase(dice_stats.diceRole.Cowboy)
	var output_text = "[center]Set a dice to a new role. \n"
	output_text += role_mgr.get_role_text(role)
	panel.text_box.text = output_text
	panel.image_box.texture = role_mgr.get_role_image(role)
	panel.button_type = upgrade_box.button_job.role

func set_dice_panel(panel: Button):
	if get_tree().get_nodes_in_group("dice").size() >= globals.max_dice:
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
	dice_upgrade_display.role_change_selction(panel.image_box.texture, _current_roles[panels.find(panel)])
	close_panel()	

func select_upgrade(panel: Button):
	dice_upgrade_display.upgrade_selection(panel.image_box.texture)
	close_panel()

func select_extra_dice():
	dice_upgrade_display.drop_extra_dice()
	close_panel()

func close_panel():
	general_upgrade_panel.hide()
	boss_upgrade_panel.hide()

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
		dice_upgrade_display.upgrade_complete()
		close_panel()


func _input(event):
	if general_upgrade_panel.visible && event.is_action_pressed("select_die"):
		var key_num = 0
		match event.keycode:
			KEY_1:
				key_num = 1
			KEY_2:
				key_num = 2
			KEY_3:
				key_num = 3
			KEY_4:
				key_num = 4
			KEY_5:
				key_num = 5
			KEY_6:
				key_num = 6
			KEY_7:
				key_num = 7
			KEY_8:
				key_num = 8
			_: 
				key_num = 0
		_focus_upgrade_choice(key_num)

func _focus_upgrade_choice(num: int):
	if num == 0 || num > panels.size():
		return
	else:
		panels[num-1].grab_focus()

func _on_focus_changed(node:Control):
	if panels.has(node):
		acceptButton.disabled = false
	else:
		acceptButton.disabled = true

func find_focussed_panel():
	for n in panels.size():
		if panels[n].has_focus():
			select_panel(n)
			break