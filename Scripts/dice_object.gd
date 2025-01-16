extends Node2D
class_name dice_object

@export var dice: DiceRes
@export var label: Label
@export var target_check_range: int = 30
@export var slot_check_range: int = 10
# @export var overlay: ColorRect
@export var lockoutBar: TextureProgressBar
var _lockoutBarMax: int
var _selected = false
var _rest_point: Vector2
var _previous_slot
var _closest_target
var _rest_nodes = []
var _target_nodes = []
var _current_roll: int
var _used = false
var _lockoutTime: float = 0
var _reducingClock: bool = false

var initialized: bool = false

func _ready():
	_rest_nodes = get_tree().get_nodes_in_group("zones")

func rollDice():
	if _used:
		_lockoutTime -=1
		_reducingClock = true
	if _lockoutTime <= 0:
		_current_roll = dice.rollDice()
		label.text = str(dice.rollDice())
		_used = false
		# overlay.color = Color(0,0,0,0)

func _on_area_2d_input_event(_viewport, _event, _shape_idx):
	#implement pickup behaviour
	if Input.is_action_just_pressed("click") && !_used:
		_check_closest(false).currentNode = null
		_selected = true


func _lockout(_lockoutLength):
	_used = true
	# overlay.color = Color(0,0,0,0.2)
	_lockoutTime = _lockoutLength
	_lockoutBarMax = _lockoutLength
	lockoutBar.max_value = _lockoutBarMax*100
	lockoutBar.value = _lockoutBarMax*100
	

func _input(event):
	#implement dropping behaviour
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and not event.pressed and not _used:
			if _closest_target != null:
				_closest_target.damage(dice.current_roll)
				_closest_target = null
				for child in _target_nodes:
					child.deselect()
				_lockout(2)
			if _selected:
				_check_closest().place(self)
			_selected = false

func _process(_delta):
	# implement dragging behaviour
	if _rest_point == Vector2.ZERO:
		_check_closest()
	elif !initialized:
		_initialize()
	if _reducingClock:
		lockoutBar.value = int(lerp(lockoutBar.value, _lockoutTime*100, 10*_delta))
		if(lockoutBar.value <= _lockoutTime*100+5):
			lockoutBar.value = _lockoutTime*100
			_reducingClock = false

func _initialize():
	# global_position = _rest_point
	# _check_closest().place(self)
	initialized = true

func _physics_process(delta):
	#implement dragging behaviour
	if _selected:
		global_position = lerp(global_position, get_global_mouse_position(), 25*delta)
		_closest_target = _check_target()
		_check_closest()
	elif initialized:
		global_position = lerp(global_position, _rest_point, 10*delta)

func _check_closest(available: bool = true):
	var shortest_dist = slot_check_range
	var closest_area
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

func upgrade():
	var _upgrade_to = dice.upgrade
	if _upgrade_to == null or _upgrade_to == dice.type:
		print("Cannot upgrade further")
		return false
	else:
		dice.type = _upgrade_to
		print("dice upgraded!")
		return true