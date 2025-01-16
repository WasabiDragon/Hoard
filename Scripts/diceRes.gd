extends Resource
class_name DiceRes

enum diceType {
	D4,
	D6,
	D8,
	D10,
	D12,
	D20,
	D100
}
enum diceClass{
	Rogue,
	Wizard,
	Warrior,
	Alchemist,
	Medic,
	Holy
}

@export var type: diceType
@export var role: diceClass
@export var current_roll: int

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
var upgrade: diceType: 
	get:
		match type:
			diceType.D4: 
				return diceType.D6
			diceType.D6: 
				return diceType.D8
			diceType.D8: 
				return diceType.D10
			diceType.D10: 
				return diceType.D12
			diceType.D12: 
				return diceType.D20
			diceType.D20: 
				return diceType.D100
			diceType.D100: 
				return diceType.D100
			_:
				return diceType

func rollDice():
	var dice_result = (randi() % DiceNumber) +1
	current_roll = dice_result
	return dice_result

