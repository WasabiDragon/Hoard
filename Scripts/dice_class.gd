extends Resource
class_name dice_class

@export var role: dice_stats.diceClass

func get_faces():
	match dice_stats.diceType:
		dice_stats.diceType.D4: 
			return D4Faces
		dice_stats.diceType.D6: 
			return D6Faces
		dice_stats.diceType.D8: 
			return D8Faces
		dice_stats.diceType.D10: 
			return D10Faces
		dice_stats.diceType.D12: 
			return D12Faces
		dice_stats.diceType.D20: 
			return D20Faces
		dice_stats.diceType.D100: 
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