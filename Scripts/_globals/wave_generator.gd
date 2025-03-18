extends Node

@onready var _pregeneratedWaveRes = preload("res://Scripts/resources/wave_pregen.gd")
@onready var _enemyIdentifier = preload("res://Scripts/resources/enemy_identifier.gd")

func get_wave(rating) -> pregenerated_wave:
	var _ratings_list = get_group_by_challenge(8,rating,false)
	return _ratings_list

func _empty_wave(size:int) -> pregenerated_wave:
	if size == 0:
		return null
	var _output: pregenerated_wave = _pregeneratedWaveRes.new()
	_output.wave.resize(size)
	for n in size:
		var id = get_blank_enemy()
		_output.wave[n] = id
	return _output

func _select_rating(number, forced = false, returnMax = false, walkersOnly = false) -> int:
	var _output_ratings = []
	#allow for zero's to be in the ratings row
	if !forced:
		_output_ratings.append(0)
	for n in globals.enemy_difficulties.keys():
		if number >= n:
			if !walkersOnly || globals.enemy_difficulties[n][0] is int:
				_output_ratings.append(n)
	if _output_ratings.size() <= 0:
		return 0
	else:
		return _output_ratings[randi() % _output_ratings.size()] if !returnMax else _output_ratings.max()

func select_cards(challengeRatings: Array[int]) -> pregenerated_wave:
	var _output_cards: pregenerated_wave = _pregeneratedWaveRes.new()
	_output_cards.wave = []
	for n in challengeRatings:
		_output_cards.wave.append(_get_enemy_res(n))
	return _output_cards

func _get_enemy_res(rating: int) -> enemy_identifier:
	var _enemy: enemy_identifier = _enemyIdentifier.new()
	var _nearest_enemy = rating
	while !globals.enemy_difficulties.keys().has(_nearest_enemy) && _nearest_enemy != 0:
		_nearest_enemy -=1
	if rating == 0:
		return get_blank_enemy()
	elif globals.enemy_difficulties[rating][0] is int:
		_enemy.type = enemy.types.card
		_enemy.identifier = globals.enemy_difficulties[rating][randi() % globals.enemy_difficulties[rating].size()]
	elif globals.enemy_difficulties[rating][0] is String:
		_enemy.type = enemy.types.wagon
		_enemy.identifier = globals.enemy_difficulties[rating][1]
	return _enemy

func get_group_by_challenge(arraySize: int, challenge: int, walkersOnly: bool = false) -> pregenerated_wave:
	var iterations = arraySize
	var remaining = challenge
	var max_challenge: int
	if !walkersOnly:
		max_challenge = globals.enemy_difficulties.keys().max()
	else:
		var max_val = 0
		for key in globals.enemy_difficulties.keys():
			if globals.enemy_difficulties[key] is Array:
				if key > max_val:
					max_val = key
		max_challenge = max_val
	# var _wave_output: Array[pregenerated_wave] = []
	var _ratings_list: Array[int] = []
	_ratings_list.resize(arraySize)

	if arraySize == 0:
		if globals.debug_enabled: print("WAVE_GEN: Unable to create array of size 0, sending null")
		return _empty_wave(arraySize)
	if challenge == 0:
		return _empty_wave(arraySize)
	for n in iterations-1:
		var _selected_rating = 0
		if (iterations - n - 1) * max_challenge > remaining:
			_selected_rating = _select_rating(remaining, true, false, walkersOnly)
		elif (iterations - n ) * max_challenge >= remaining:
			_selected_rating = remaining % max_challenge if remaining % max_challenge != 0 else max_challenge
			while !globals.enemy_difficulties.keys().has(_selected_rating):
				_selected_rating -= 1
				remaining -= 1				
		elif (iterations -n)*max_challenge < remaining:
			if globals.debug_enabled: print("WAVE_GEN: Too high of a challenge to fit in %s columns" % str(iterations-n))
			return _empty_wave(iterations)
		_ratings_list[n] = _selected_rating
		remaining -= _selected_rating
	_ratings_list[iterations-1] = _select_rating(remaining, true, true, walkersOnly)
	_ratings_list.shuffle()
	return select_cards(_ratings_list)

func get_unique_random_enemies(maxRating: int, quantity: int) -> Array[enemy_identifier]:
	var _enemy: enemy_identifier = _enemyIdentifier.new()
	var options: Array = get_all_options(maxRating, quantity)
	var output_list: Array[enemy_identifier] = []
	for n in quantity:
		output_list.append(options.pop_at(randi() % options.size()))
	output_list.sort_custom(_custom_sort_enemy_difficulty)
	return output_list

func match_check(enemy_id:enemy_identifier, list: Array) -> bool:
	for id in list:
		if id.type == enemy_id.type && id.identifier == enemy_id.identifier:
			return true
	return false

func out_of_options_check(maxRating: int, currentList: Array, quantity: int) -> bool:
	var targets = get_all_options(maxRating, quantity)
	if currentList.size() >= targets.size():
		return true
	return false

### Max value is the maximum rating in challenge_ratings (currently 100 @ 13/03/2025)
func get_all_options(maxRating: int, minimumNeeded: int) -> Array[enemy_identifier]:
	if globals.debug_enabled: print("WAVE_GEN: requesting all options easier than %d"%[maxRating])
	var collection = _get_uniques_within_max_ratings(maxRating)
	var increase_range = 0
	while collection.size() < minimumNeeded:
		increase_range +=1
		if globals.debug_enabled: print("WAVE_GEN: requesting all options easier than %d"%[maxRating+increase_range])
		collection = _get_uniques_within_max_ratings(maxRating+increase_range)
	if globals.debug_enabled: print("WAVE_GEN: %d"%[collection.size()])
	return collection

func _get_uniques_within_max_ratings(maxRating: int) -> Array[enemy_identifier]:
	var available_keys = []
	var targets: Array[enemy_identifier] = []
	for n in globals.enemy_difficulties.size():
			if globals.enemy_difficulties.keys()[n] <= maxRating:
				available_keys.append(globals.enemy_difficulties.keys()[n])
	for n in available_keys:
		if globals.enemy_difficulties[n][0] is int:
			for rating in globals.enemy_difficulties[n]:
				var _enemy: enemy_identifier = _enemyIdentifier.new()	
				if globals.debug_enabled: print("WAVE_GEN: round %d: cardcheck: %d"%[n,rating])
				_enemy.type = enemy.types.card
				_enemy.identifier = rating
				if !match_check(_enemy, targets):
					targets.append(_enemy)
					if globals.debug_enabled: print("WAVE_GEN: Enemy added: CARD - %s"%[str(rating)])
		elif globals.enemy_difficulties[n][0] is String:
			var _enemy: enemy_identifier = _enemyIdentifier.new()	
			_enemy.type = enemy.types.wagon
			_enemy.identifier = globals.enemy_difficulties[n][1]
			if !match_check(_enemy, targets):
				targets.append(_enemy)
				if globals.debug_enabled: print("WAVE_GEN: Enemy added: WAGON - %s"%[str(globals.enemy_difficulties[n][0])])
	return targets

func _custom_sort_enemy_difficulty(enemy1:enemy_identifier, enemy2:enemy_identifier) -> bool:
	if enemy1.type == enemy2.type:
		return enemy1.identifier < enemy2.identifier
	var wagon_value = enemy1.identifier if enemy1.type == enemy.types.wagon else enemy2.identifier
	var card_value = enemy1.identifier if enemy1.type == enemy.types.card else enemy2.identifier
	if wagon_value == 0 && card_value <= 10:
		return enemy1.type == enemy.types.wagon
	elif wagon_value == 1 && card_value <= 12:
		return enemy1.type == enemy.types.wagon
	elif wagon_value > 1 && card_value <= 13:
		return enemy1.type == enemy.types.wagon
	else:
		return enemy1.type == enemy.types.card

func get_blank_enemy() -> enemy_identifier:
	var id = _enemyIdentifier.new()
	id.identifier = 0
	id.type = enemy.types.none
	return id