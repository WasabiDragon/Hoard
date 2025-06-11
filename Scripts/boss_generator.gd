extends Node

@onready var boss_round_template = preload("res://Scripts/resources/boss_round.gd")
@onready var boss_wave_template = preload("res://Scripts/resources/boss_wave.gd")
@onready var pregenerated_wave_template = preload("res://Scripts/resources/wave_pregen.gd")

func generate_boss(difficulty: int):
	return _populate_boss(_pick_random_template(),difficulty)

func generate_unique_bosses(difficulty:int, quantity:int) -> Array[boss_round]:
	var output: Array[boss_round] = []
	var selected_templates: Array[boss_template] = _pick_random_unique_templates(quantity)
	for template in selected_templates:
		output.append(_populate_boss(template,difficulty))
	return output


func _pick_random_template() -> boss_template:
	var boss_templates = $/root/Main/game_controller/level_list.boss_templates
	return boss_templates[randi() % boss_templates.size()].duplicate()

func _pick_random_unique_templates(quantity: int) -> Array[boss_template]:
	var boss_templates: Array[boss_template] = $/root/Main/game_controller/level_list.boss_templates.duplicate()
	var output: Array[boss_template] = [] 
	for n in quantity:
		if quantity > boss_templates.size():
			print("Not enough boss templates to create unique bosses. Picking randomly instead.")
			output.append(_pick_random_template())
		else:
			var selected_template = boss_templates.pop_at(randi() % boss_templates.size())
			output.append(selected_template)
			var new_list: Array[boss_template]
			for template in boss_templates:
				if template.boss_name != selected_template.boss_name:
					new_list.append(template)
			boss_templates = new_list
	return output

func _populate_boss(template: boss_template, difficulty: int) -> boss_round:
	if globals.debug_enabled: print("BOSS_GEN: Creating boss from %s"%[template.boss_name])
	var random_suit_key = card_type.suit.keys()[randi() % card_type.suit.size()]
	var instance_round = boss_round_template.new()
	var instance_wave = boss_wave_template.new()
	instance_wave.pregenerated = true
	var instance_pregen_wave = pregenerated_wave_template.new()
	var transfer = {}
	var uniques = template.get_uniques()
	var unique_pack = get_cards(difficulty, uniques.size())
	for number in uniques:
		transfer[number] = unique_pack.pop_at(0)
	for wave in template.waves:
		var wave_dupe = instance_wave.duplicate()
		var pregen_dupe = instance_pregen_wave.duplicate()
		for num in wave.wave:
			var enemy_to_input: enemy_identifier
			if num == 0:
				enemy_to_input = wave_gen.get_blank_enemy()
			else:
				enemy_to_input = transfer[num]
				if template.boss_name.to_lower().contains("flush"):
					enemy_to_input.enable_suit_override = true
					enemy_to_input.suit_override = card_type.suit[random_suit_key]
			pregen_dupe.wave.append(enemy_to_input)
		wave_dupe.pregen_wave = pregen_dupe
		instance_round.boss_round_info.append(wave_dupe)
	instance_round.boss_round_name = template.boss_name
	return instance_round

func get_cards(maxDifficulty:int, quantity: int) -> Array[enemy_identifier]:
	return wave_gen.get_unique_random_enemies(maxDifficulty, quantity)