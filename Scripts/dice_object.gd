extends Node2D
class_name dice_object

@export var dice: dice_stats
@export var target_check_range: int = 30
@export var slot_check_range: int = 10
@export var lockout_mgr: dice_lockout_mgr
@export var visual_mgr: dice_visual_mgr
@export var audio_mgr: dice_audio_mgr


@onready var _custom_tooltip = $custom_tooltip
@onready var _role_mgr: role_manager = get_parent().role_mgr
@onready var _dam_calc: damage_calc = get_node("/root/Main/game_controller/damage_calculator")

var _selected = false
var _rest_point: Vector2
var _previous_slot
var _closest_target
var _rest_nodes = []
var _target_nodes = []
var _remainingRolls: int = 1
var initialized: bool = false
var locked_out: bool:
	get:
		return lockout_mgr.locked_out

func _ready():
	connect_signals()

func connect_signals():
	signals.turn_ended.connect(roll_dice_check)
	signals.refresh_all.connect(refresh_lockout)

func roll_dice_check():
	if _remainingRolls < _role_mgr.get_multi_roll(dice) && !lockout_mgr.locked_out:
		_lockout(_role_mgr.get_lockout_time(dice))
	if lockout_mgr.attempt_roll():
		roll_dice()
		_remainingRolls = _role_mgr.get_multi_roll(dice)

func roll_dice():
	audio_mgr.rollSound()
	dice.rollDice()
	update_face()
	update_tooltip()

func use_die():
	if _closest_target != null:
		_remainingRolls -= 1
		_dam_calc.attack(dice, _closest_target)
		audio_mgr.attackSound()
		_closest_target = null
		for child in _target_nodes:
			child.deselect()
		if _remainingRolls <= 0:
			_lockout(_role_mgr.get_lockout_time(dice))
		else:
			_remainingRolls = _role_mgr.get_multi_roll(dice)
			roll_dice()

func _lockout(_lockoutLength):
	lockout_mgr.lockout(_lockoutLength)

func _process(_delta):
	if _rest_point == Vector2.ZERO:
		_check_closest()
	if !initialized && _rest_point != Vector2.ZERO:
		_initialize()

func _initialize():
	global_position = _rest_point
	_check_closest().place(self)
	update_tooltip()
	visual_mgr.set_image(_role_mgr.get_dice_image(dice))
	initialized = true

#region = Movement
func _on_area_2d_input_event(_viewport, _event, _shape_idx):
	#implement pickup behaviour
	if Input.is_action_just_pressed("click") && !lockout_mgr.locked_out:
		_check_closest(false).currentNode = null
		_selected = true
	elif Input.is_action_just_pressed("click") && lockout_mgr.locked_out:
		audio_mgr.lockedSound()

func _input(event):
	#implement dropping behaviour
	if _dam_calc == null:
		_dam_calc = get_node("/root/Main/game_controller/damage_calculator")
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and not event.pressed and not lockout_mgr.locked_out:
			use_die()
			if _selected:
				_check_closest().place(self)
			_selected = false

func reset_position() -> void:
	_check_closest(true)
	global_position = _rest_point

func _physics_process(delta):
	#implement dragging behaviour
	if _selected:
		global_position = lerp(global_position, get_global_mouse_position(), 25*delta)
		_closest_target = _check_target()
		_check_closest()
	elif initialized && global_position.distance_to(_rest_point) > 1:
		global_position = lerp(global_position, _rest_point, 10*delta)
#endregion = Movement

#region = LocateTargets
func _check_closest(available: bool = true):
	var shortest_dist = slot_check_range
	var closest_area
	_rest_nodes = get_tree().get_nodes_in_group("zones")
	if available:
		for child in _rest_nodes:
			var distance = global_position.distance_to(child.global_position)
			if distance < shortest_dist && child.available:
				closest_area = child
				shortest_dist = distance
		if closest_area == null:
			closest_area = _previous_slot
		if closest_area != null:
			closest_area.select()
			_rest_point = closest_area.global_position
			_previous_slot = closest_area
	else:
		for child in _rest_nodes:
			var distance = global_position.distance_to(child.global_position)
			if (distance < shortest_dist || shortest_dist == slot_check_range):
				closest_area = child
				shortest_dist = distance
	return closest_area

func _check_target():
	_target_nodes = get_tree().get_nodes_in_group("targets")
	var shortest_dist = target_check_range
	var closest_target_check
	for child in _target_nodes:
		var distance = global_position.distance_to(child.global_position)
		if(distance < shortest_dist):
			closest_target_check = child
			shortest_dist = distance
	if closest_target_check == null:
		for child in _target_nodes:
			child.deselect()
	else:
		closest_target_check.select()
		closest_target_check = closest_target_check.get_parent()
	return closest_target_check
#endregion = LocateTargets

func upgrade() -> bool:
	var _upgradable: bool = dice.upgrade()
	if _upgradable:
		visual_mgr.set_image(_role_mgr.get_dice_image(dice))
		update_tooltip()
		update_face()
		return true
	else:
		print("Cannot upgrade further")
		return false

func changeClass(diceRole: dice_stats.diceRole) -> bool:
	if dice.role == diceRole:
		print("failed to change class")
		return false
	else:
		dice.role = diceRole
		update_tooltip()
		visual_mgr.set_class(_role_mgr.get_role_image(dice.role))
		visual_mgr.set_image(_role_mgr.get_dice_image(dice))
		update_face()
		print("success")
		return true

func reduce_lockout() -> void:
	lockout_mgr.reduce_lockout()

func refresh_lockout() -> void:
	lockout_mgr.refresh_lockout()

func update_tooltip() -> void:
	_custom_tooltip.update_tooltip(dice)

func update_face() -> void:
	visual_mgr.set_face(_role_mgr.get_dice_face(dice))

