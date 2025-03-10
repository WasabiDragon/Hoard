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
	var quantity = 0
	if levelNum == 0:
		quantity = 1
	else:
		quantity = 2 if randf() > 0.5 else 3
	var info: level_gen_stats = level_list.levelInfoList[levelNum]
	var variance = info.wave_variance
	var levels: Array[level] = []
	print("Making %d map choices"%[quantity])
	var boss_rewards = rewards.generate_boss_rewards(quantity)
	print("Created %d boss rewards"%[boss_rewards.size()])
	for n in boss_rewards.size():
		var waves = randi_range(info.waves-variance, info.waves+variance)
		var generated_level = level_gen.create_level(waves, info.minTier, info.maxTier, info.bossTier)
		if generated_level == null:
			print("Map creation failed.")
			return false
		generated_level.rounds[-1].boss.reward = boss_rewards[n]
		levels.append(generated_level)

	_set_map_options(levels, levelNum)
	return true

func _set_map_options(levels: Array[level], levelNum: int):
	level_label.text = "Choose level %d"%[levelNum+1]
	for n in map_options.size():
		if n >= levels.size():
			print("Hiding map option %d"%[n])
			map_options[n].get_parent().hide()
		else:
			print("Setting map option %d"%[n])
			map_options[n].set_level(levels[n])
			var image = dice_upgrade_image if levels[n].rounds[-1].boss.reward.type == reward_obj.reward.DIE else role_mgr.get_role_image(levels[n].rounds[-1].boss.reward.role)
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
	if number > map_options.size() || number == 0:
		return
	elif map_options[number-1].visible:
		map_options[number-1].select()