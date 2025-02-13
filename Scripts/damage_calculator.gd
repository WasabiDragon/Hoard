extends Node
class_name damage_calc

var spawn: spawner
var explosion_radius: float
@export var crit_chance: float
@export var float_text: floating_text
@export var timings: game_controller
@export var role_mgr: role_manager
var target_text_color: Color

func _ready():
	spawn = %enemy_spawner

func attack(dice_input: dice_stats, target: Node):
	target_text_color = Color.WHITE
	role_mgr.use_dice(dice_input, target)

func apply_damage(target: Node, damage: int) -> void:
	float_text.spawn_text(target.global_position, str(damage), target_text_color)
	target.damage(damage)
