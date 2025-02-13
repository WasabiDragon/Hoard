extends Node
class_name dice_stats

enum diceType {
	D4,
	D6,
	D8,
	D10,
	D12,
	D20,
	D100
}
enum diceRole{
	Bartend,
	Cowboy,
	Deadeye,
	Demolisher,
	Deputy,
	Madam,
	Quickshot
}

@export var type: diceType
@export var role: diceRole
@export var current_roll: int

func Initialize():
	type = diceType.D4
	role = diceRole.Cowboy
	current_roll = 1


var DiceNumber: int: 
	get:
		match type:
			diceType.D4: 
				return 4
			diceType.D6: 
				return 6
			diceType.D8: 
				return 8
			diceType.D10: 
				return 10
			diceType.D12: 
				return 12
			diceType.D20: 
				return 20
			diceType.D100: 
				return 100
			_:
				return 0

func upgrade():
	match type:
		diceType.D4: 
			type = diceType.D6
			return true
		diceType.D6: 
			type = diceType.D8
			return true
		diceType.D8: 
			type = diceType.D10
			return true
		diceType.D10: 
			type = diceType.D12
			return true
		diceType.D12: 
			type = diceType.D20
			return true
		diceType.D20: 
			type = diceType.D100
			return true
		diceType.D100: 
			type = diceType.D100
			return false
		_:
			return false

func rollDice():
	var dice_result = (randi() % DiceNumber) +1
	current_roll = dice_result
	return dice_result