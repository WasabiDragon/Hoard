extends Node
class_name map_manager

@export var level_list: level_list_class
@export var map_options: Array[map_option]
@export var map_option_display: Control
@export var level_label: RichLabelAutoSizer
@export var dice_upgrade_image: Texture2D
@export var role_mgr: role_manager

func _ready():
	signals.map_option_selected.connect(hide_all)

func create_next_map(levelNum: int) -> bool:
	var quantity = 2 if randf() > 0.5 else 3
	var info: level_gen_globals = level_list.levelInfoList[levelNum]
	var variance = info.wave_variance
	var levels: Array[level] = []
	var boss_rewards = rewards.generate_boss_rewards(quantity)
	var difficulty = ceili((float(globals.enemy_difficulties.size()) / 10)*(levelNum+1))
	var bosses = boss_gen.generate_unique_bosses(difficulty, quantity)
	for n in quantity:
		var waves = randi_range(info.waves-variance, info.waves+variance)
		var generated_level = level_gen.create_level(waves, levelNum,levelNum, info.bossTier)
		if generated_level == null:
			print("Map creation failed.")
			return false
		level_gen.add_boss_manually_to_level(generated_level, bosses[n])
		generated_level.rounds[-1].boss.boss_reward = boss_rewards[n]
		levels.append(generated_level)
	_set_map_options(levels, levelNum)
	return true

func _set_map_options(levels: Array[level], levelNum: int):
	level_label.text = "Choose level %d"%[levelNum+1]
	for n in map_options.size():
		if n >= levels.size():
			map_options[n].get_parent().hide()
		else:
			map_options[n].set_level(levels[n])
			var image: Texture2D
			match levels[n].rounds[-1].boss.boss_reward.type:
				reward_obj.reward.DIE:
					image = dice_upgrade_image
				reward_obj.reward.ROLE:
					image = role_mgr.get_role_image(levels[n].rounds[-1].boss.boss_reward.role)
				reward_obj.reward.CONSUMABLE:
					image = levels[n].rounds[-1].boss.boss_reward.consumable_reward.highlight_image
			map_options[n].set_image(image)
			map_options[n].set_boss_name(levels[n].rounds[-1].boss.boss_round_name)
			map_options[n].get_parent().show()
	map_option_display.show()

func _input(event):
	if map_option_display.visible && event.is_action_pressed("select_die"):
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
		select_map_option(key_num)

func hide_all(_void = null):
	map_option_display.hide()

func select_map_option(number: int):
	var visible_panels = 0
	for opt in map_options:
		if opt.visible:
			visible_panels +=1
	if number > visible_panels || number == 0:
		return
	elif map_options[number-1].visible:
		map_options[number-1].select()