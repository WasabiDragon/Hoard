extends Node
class_name role_information

@export var role: dice_stats.diceRole
@export var damage_mult: float = 1
@export var dice_cooldown: int = 2
@export var role_text: String
var role_description:
	get:
		var replacement_text = "[color=#%s]%s[/color]"%[role_color.to_html(false), dice_stats.diceRole.keys()[role]]
		var output_text = role_text.replace("ROLE", replacement_text)
		return output_text
@export var upgrade_text: String
@export_color_no_alpha var role_color: Color
var upgrade_description:
	get:
		return upgrade_text.replace("LVL", str(role_level+1))
var role_level = 1

@export var role_image: Texture2D
@export var dice_sprites: Texture2D
@export var sprite_size: int

@onready var damager: damage_calc = get_parent().damageCalculator

func _ready():
	signals.restarting.connect(reset)

func get_dice_image(type: dice_stats.diceType) -> AtlasTexture:
	var output_atlas = AtlasTexture.new()
	output_atlas.atlas = dice_sprites
	output_atlas.region.size = Vector2(sprite_size,sprite_size)
	output_atlas.region.position = Vector2(0,sprite_size*(type))
	return output_atlas

func get_role_image() ->Texture2D:
	return role_image

func use_dice(_info: dice_stats, _target: Node):
	push_error("Use dice not implemented on "+name)
	return

func reset():
	role_level = 1