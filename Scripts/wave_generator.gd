extends Node

var _challenge_1:= [1,2,3]
var _challenge_2:= [4,5,6]
var _challenge_3:= [7,8]
var _challenge_6:= [9,10]
var _challenge_18:= [11,12]
var _challenge_22:= [13]
var _ratings = [1,2,3,6,18,22]

func get_wave(rating) -> Array[int]:
	var lanes = 8
	var remaining = rating
	var _wave_output: Array[int] = []
	if rating == 0:
		return [0,0,0,0,0,0,0,0]
	for n in lanes-1:
		var _selected_rating = 0
		if (lanes - n - 1) * 22 > remaining:
			_selected_rating = _select_rating(remaining)
		elif (lanes - n ) * 22 >= remaining:
			_selected_rating = remaining % 22 if remaining % 22 != 0 else 22
			while !_ratings.has(_selected_rating):
				_selected_rating -= 1
				remaining -= 1				
		elif (lanes -n)*22 < remaining:
			print("Too high of a challenge to fit in %s columns" % str(lanes-n))
			return [0,0,0,0,0,0,0,0]
		_wave_output.append(_selected_rating)
		remaining -= _selected_rating
	_wave_output.append(_select_rating(remaining, true))
	_wave_output.shuffle()
	return _select_card(_wave_output)


func _select_rating(number, forced = false) -> int:
	var _output_ratings = []
	if !forced:
		_output_ratings.append(0)
	for n in _ratings:
		if number >= n:
			_output_ratings.append(n)
	if _output_ratings.size() <= 0:
		return 0
	else:
		return _output_ratings[randi() % _output_ratings.size()]

func _select_card(challengeRatings: Array[int]) -> Array[int]:
	var _output_cards:Array[int] = []
	for n in challengeRatings:
		if n == 0:
			_output_cards.append(0)
		elif n == 1:
			_output_cards.append(_challenge_1[randi() % _challenge_1.size()])
		elif n == 2:
			_output_cards.append(_challenge_2[randi() % _challenge_2.size()])
		elif n == 3:
			_output_cards.append(_challenge_3[randi() % _challenge_3.size()])
		elif n == 6:
			_output_cards.append(_challenge_6[randi() % _challenge_6.size()])
		elif n == 18:
			_output_cards.append(_challenge_18[randi() % _challenge_18.size()])
		elif n == 22:
			_output_cards.append(_challenge_22[randi() % _challenge_22.size()])
		else:
			print("ERROR SELECTING CARDS")
	return _output_cards
		