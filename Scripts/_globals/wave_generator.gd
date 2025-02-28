extends Node

var _challenge_ratings: Dictionary = {
	1:[1,2,3,4],
	2:[2,3,4,5],
	3:[3,4,5,6],
	4:[4,5,6,7],
	5:[5,6,7,8],
	6:[6,7,8,9],
	7:[7,8,9,10],
	8:[8,9,10],
	9:[9,10],
	10:[10],
	15:["wagon_easy", 3],
	25:[11,12],
	26:["wagon_medium", 10],
	30:[13],
	50:["wagon_hard", 25],
	90:["wagon_royal", 75]
}

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
		var id = _enemyIdentifier.new()
		id.identifier = 0
		id.type = enemy.types.none
		_output.wave[n] = id
	return _output

func _select_rating(number, forced = false, returnMax = false, walkersOnly = false) -> int:
	var _output_ratings = []
	#allow for zero's to be in the ratings row
	if !forced:
		_output_ratings.append(0)
	for n in _challenge_ratings.keys():
		if number >= n:
			if !walkersOnly || _challenge_ratings[n] is Array:
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
	while !_challenge_ratings.keys().has(_nearest_enemy) && _nearest_enemy != 0:
		_nearest_enemy -=1
	if rating == 0:
		_enemy.type = enemy.types.none
		_enemy.identifier = 0
	elif _challenge_ratings[rating][0] is int:
		_enemy.type = enemy.types.card
		_enemy.identifier = _challenge_ratings[rating][randi() % _challenge_ratings[rating].size()]
	elif _challenge_ratings[rating][0] is String:
		_enemy.type = enemy.types.wagon
		_enemy.identifier = _challenge_ratings[rating][1]
	return _enemy

func get_group_by_challenge(arraySize: int, challenge: int, walkersOnly: bool = false) -> pregenerated_wave:
	var iterations = arraySize
	var remaining = challenge
	var max_challenge: int
	if !walkersOnly:
		max_challenge = _challenge_ratings.keys().max()
		print(_challenge_ratings.keys().max())
	else:
		var max_val = 0
		for key in _challenge_ratings.keys():
			if _challenge_ratings[key] is Array:
				if key > max_val:
					max_val = key
		max_challenge = max_val
	# var _wave_output: Array[pregenerated_wave] = []
	var _ratings_list: Array[int] = []
	_ratings_list.resize(arraySize)

	if arraySize == 0:
		print("Unable to create array of size 0, sending null")
		return _empty_wave(arraySize)
	if challenge == 0:
		return _empty_wave(arraySize)
	for n in iterations-1:
		var _selected_rating = 0
		if (iterations - n - 1) * max_challenge > remaining:
			_selected_rating = _select_rating(remaining, true, false, walkersOnly)
		elif (iterations - n ) * max_challenge >= remaining:
			_selected_rating = remaining % max_challenge if remaining % max_challenge != 0 else max_challenge
			while !_challenge_ratings.keys().has(_selected_rating):
				_selected_rating -= 1
				remaining -= 1				
		elif (iterations -n)*max_challenge < remaining:
			print("Too high of a challenge to fit in %s columns" % str(iterations-n))
			return _empty_wave(iterations)
		_ratings_list[n] = _selected_rating
		remaining -= _selected_rating
	_ratings_list[iterations-1] = _select_rating(remaining, true, true, walkersOnly)
	_ratings_list.shuffle()
	return select_cards(_ratings_list)
