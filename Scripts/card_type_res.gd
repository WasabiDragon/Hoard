extends Resource
class_name card_type

enum suit
{
	Spade,	
	Club,
	Diamond,
	Heart
}

@export_range(0,13) var card_number: int
@export var card_suit: suit
@export var card_texture: Texture2D