@tool
extends Resource
class_name enemy_identifier

@export var type: enemy.types
@export var identifier: int
@export var enable_suit_override: bool = false
@export var suit_override: card_type.suit
