extends Resource
class_name consumable

@export var type: consumable_manager.consumableType
@export var image: Texture2D
@export var highlight_image: Texture2D
@export_multiline var description: String
@export var uses:int = 0
var active = false
