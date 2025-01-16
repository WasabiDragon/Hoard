extends Resource
class_name DiceClass

@export var role: DiceRes.diceClass

func get_faces():
	match DiceRes.diceType:
		DiceRes.diceType.D4: 
			return D4Faces
		DiceRes.diceType.D6: 
			return D6Faces
		DiceRes.diceType.D8: 
			return D8Faces
		DiceRes.diceType.D10: 
			return D10Faces
		DiceRes.diceType.D12: 
			return D12Faces
		DiceRes.diceType.D20: 
			return D20Faces
		DiceRes.diceType.D100: 
			return D100Faces
		_:
			return null

@export var D4Faces: Array[int]
@export var D6Faces: Array[int]
@export var D8Faces: Array[int]
@export var D10Faces: Array[int]
@export var D12Faces: Array[int]
@export var D20Faces: Array[int]
@export var D100Faces: Array[int]