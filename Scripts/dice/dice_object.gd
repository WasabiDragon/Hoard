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

var _grabbed = false
var selected = false
var _rest_point: Node
# var _previous_slot
var _closest_target
# var _rest_nodes = []
var _target_nodes = []
var _remainingRolls: int = 1
var initialized: bool = false
var locked_out: bool:
	get:
		return lockout_mgr.locked_out

var held_upgrades = 0

func _ready():
	connect_signals()

func connect_signals():
	signals.turn_ended.connect(roll_dice_check)
	signals.roll_dice.connect(roll_dice_check)
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
			if selected:
				signals.emit_select_next_dice()
		else:
			roll_dice()

func _lockout(_lockoutLength):
	lockout_mgr.lockout(_lockoutLength)

func _process(_delta):
	if _rest_point != null:
		if _rest_point && _rest_point.global_position == Vector2.ZERO:
			print("rest point not given")
		if !initialized && _rest_point.global_position != Vector2.ZERO:
			_initialize()
	if selected and not locked_out:
		_closest_target = _check_for_target_near_pos(get_global_mouse_position())

func _initialize():
	print("Initializing die")
	global_position = _rest_point.global_position
	# _check_closest().place(self)
	update_tooltip()
	visual_mgr.set_font_color(_role_mgr.get_font_color(dice.role))
	visual_mgr.set_dice(_role_mgr.get_dice_image(dice))
	_rest_point.set_upgrades(held_upgrades, dice_stats.diceType.values()[dice.type]+1)
	initialized = true
	show()

#region = Movement
func _on_area_2d_input_event(_viewport, _event, _shape_idx):
	#implement pickup behaviour
	if Input.is_action_just_pressed("click") && !lockout_mgr.locked_out:
		# _check_closest(false).currentNode = null
		_grabbed = true
	elif Input.is_action_just_pressed("click") && lockout_mgr.locked_out:
		audio_mgr.lockedSound()

func _input(event):
	#implement dropping behaviour
	if _dam_calc == null:
		_dam_calc = get_node("/root/Main/game_controller/damage_calculator")
	if event.is_action("click"):
		if not event.pressed and not locked_out:
			use_die()
			_grabbed = false
		elif not event.pressed and selected and locked_out:
			audio_mgr.lockedSound()

func reset_position() -> void:
	# _check_closest(true)
	global_position = _rest_point.global_position

func _physics_process(delta):
	#implement dragging behaviour
	if _grabbed:
		global_position = lerp(global_position, get_global_mouse_position(), 25*delta)
		_closest_target = _check_for_target_near_pos(global_position)
	elif initialized && global_position.distance_to(_rest_point.global_position) > 1:
		global_position = lerp(global_position, _rest_point.global_position, 10*delta)
#endregion = Movement

#region = LocateTargets
func _check_for_target_near_pos(position_to_target: Vector2):
	_target_nodes = get_tree().get_nodes_in_group("targets")
	var shortest_dist = target_check_range
	var closest_target_check
	for child in _target_nodes:
		var distance = position_to_target.distance_to(child.global_position)
		if(distance < shortest_dist):
			closest_target_check = child
			shortest_dist = distance
	if closest_target_check == null:
		for child in _target_nodes:
			child.deselect()
	else:
		if dice.role == dice_stats.diceRole.Quickshot && closest_target_check.get_parent().gridPosition.y < stats.ranks-1-_role_mgr.quickshot_distance():
			closest_target_check = null
		else:
			closest_target_check.select()
			closest_target_check = closest_target_check.get_parent()
	return closest_target_check
#endregion = LocateTargets

func upgrade() -> bool:
	if dice.upgradeable:
		if held_upgrades < dice_stats.diceType.values()[dice.type]:
			held_upgrades +=1
		else:
			dice.upgrade()
			visual_mgr.set_dice(_role_mgr.get_dice_image(dice))
			update_tooltip()
			update_face()
			held_upgrades = 0
		_rest_point.set_upgrades(held_upgrades, dice_stats.diceType.values()[dice.type]+1)
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
		visual_mgr.set_font_color(_role_mgr.get_font_color(diceRole))
		visual_mgr.set_dice(_role_mgr.get_dice_image(dice))
		_rest_point.find_child("class_image").texture = _role_mgr.get_role_image(dice.role)
		update_face()
		signals.emit_quickshot() ## checks if any dice are quickshot to enable the distance line
		return true

func reduce_lockout() -> void:
	lockout_mgr.reduce_lockout()

func refresh_lockout() -> void:
	_remainingRolls = _role_mgr.get_multi_roll(dice)
	lockout_mgr.refresh_lockout()

func update_tooltip() -> void:
	_custom_tooltip.update_tooltip(dice)

func update_face() -> void:
	visual_mgr.set_face(_role_mgr.get_dice_face(dice))

func deselect():
	selected = false
	if _closest_target != null:
		for child in _target_nodes:
			child.deselect()
		_closest_target = null