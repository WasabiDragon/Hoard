extends Node
class_name damage_calc

var spawn: spawner
@export var _dice_spawner: dice_spawner
var explosion_radius: float
@export var crit_chance: float
@export var float_text: floating_text
@export var timings: timing_controller
var _burn_list = {}
var targetColor: Color

func _ready():
	spawn = %enemy_spawner
	

func attack(dice_input: dice_stats, target: Node):
	targetColor = Color.WHITE
	var damage_output = 0
	match dice_input.role:
		dice_stats.diceClass.Basic:
			_apply_damage(target, dice_input.current_roll)
		dice_stats.diceClass.Rogue:
			damage_output = _crit_check(dice_input.current_roll)
			_apply_damage(target, damage_output)
		dice_stats.diceClass.Wizard:
			explosion_radius = spawn._laneSize if spawn._laneSize > spawn._rankSize else spawn._rankSize
			explosion_radius += 1
			damage_output = dice_input.current_roll
			for child in spawn.spawn_parent.get_children():
				if target.global_position.distance_to(child.global_position) <= explosion_radius:
					_apply_damage(child, damage_output)
		dice_stats.diceClass.Warrior:
			_apply_damage(target, dice_input.current_roll)
		dice_stats.diceClass.Alchemist:
			_apply_damage(target, dice_input.current_roll)
			_add_to_burn_list(target, dice_input)
		dice_stats.diceClass.Medic:
			_apply_damage(target, dice_input.current_roll)
			_reduce_lockout(dice_input)
		dice_stats.diceClass.Holy:
			_apply_damage(target, dice_input.current_roll)
		_:
			_apply_damage(target, dice_input.current_roll)

func _apply_damage(target: Node, damage: int) -> void:
	float_text.spawn_text(target.global_position, str(damage), targetColor)
	target.damage(damage)
	timings.end_level_check()


func _crit_check(damage: int) -> int:
	if randi()%100 <= crit_chance:
		targetColor = Color.RED
		return damage*2
	else:
		return damage

func apply_burns() -> void:
	for key in _burn_list.keys():
		if _burn_list[key] == null:
			continue
		if _burn_list[key][0] == null || _burn_list[key][2] == 0:
			_burn_list[key] = null
		elif _burn_list[key][2] > 0:
			_burn_list[key][2] -= 1
			_apply_damage(_burn_list[key][0], _burn_list[key][1])

func _add_to_burn_list(target: Node, dice_input: dice_stats):
	var _found_slot = false
	for key in _burn_list.keys():
		if _burn_list[key] == null:
			_burn_list[key] = [target, dice_input.current_roll, 2]
			_found_slot = true
			break
	if !_found_slot:
		_burn_list["target"+str(_burn_list.size())] = [target, dice_input.current_roll, 2]

func _reduce_lockout(dice_input: dice_stats) -> void:
	var dice_list = []
	for child: dice_object in _dice_spawner.get_children():
		if child.locked_out && child.dice != dice_input:
			dice_list.append(child)
	if dice_list != null && dice_list.size() > 0:
		dice_list[randi() % dice_list.size()].reduce_lockout()

