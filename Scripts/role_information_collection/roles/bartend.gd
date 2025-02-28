extends role_information

var _burnList = {}
@export var _defaultBurnDuration: int

var burnDuration:
	get:
		return _defaultBurnDuration + role_level

func _ready():
	connect_signals()

func connect_signals() -> void:
	signals.turn_ended.connect(apply_burns)

func use_dice(info: dice_stats, target: Node) -> void:
	damager.apply_damage(target, info.current_roll)
	_add_to_burn_list(target, info)


func _add_to_burn_list(target: Node, dice_input: dice_stats) -> void:
	var _found_slot = false
	_enable_burn_anim(target, burnDuration)
	for key in _burnList.keys():
		if _burnList[key] == null:
			_burnList[key] = [target, dice_input.current_roll, burnDuration]
			_found_slot = true
			break
	if !_found_slot:
		_burnList["target"+str(_burnList.size())] = [target, dice_input.current_roll, burnDuration]

func apply_burns() -> void:
	for key in _burnList.keys():
		if _burnList[key] == null:
			continue
		if _burnList[key][0] == null || _burnList[key][2] == 0:
			_burnList[key] = null
		elif _burnList[key][2] > 0:
			damager.apply_damage(_burnList[key][0], _burnList[key][1])
			_burnList[key][2] -= 1
			if _burnList[key][2] <= 0:
				_disable_burn_anim(_burnList[key][0])
			else:
				_reduce_burn_anim_counter(_burnList[key][0],_burnList[key][2])

func _enable_burn_anim(target, turns_to_burn):
	target.enable_burn_anim(turns_to_burn)

func _reduce_burn_anim_counter(target, turns_to_burn):
	target.reduce_burn_counter(turns_to_burn)

func _disable_burn_anim(target):
	target.disable_burn_anim()