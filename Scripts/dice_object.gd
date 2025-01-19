extends Node2D
class_name dice_object

@export var dice: dice_stats
@export var label: Label
@export var target_check_range: int = 30
@export var slot_check_range: int = 10
@export var sprite: Sprite2D
# @export var overlay: ColorRect
@export var lockoutBar: TextureProgressBar
@export var images: dice_images
@export var dice_class_image: Sprite2D

@onready var _attackSound = $AttackSound as audio_bank
@onready var _lockedSound = $LockedSound as audio_bank
@onready var _rollSound = $RollSound as audio_bank

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
@onready var _dam_calc: damage_calc = get_node("/root/Main/damage_calculator")
var _doubleRoll: bool = false

var initialized: bool = false

var locked_out: bool:
	get:
		return _lockoutTime > 0

func _ready():
	_rest_nodes = get_tree().get_nodes_in_group("zones")

func roll_dice_check():
	if _used:
		_lockoutTime -=1
		_reducingClock = true
	if _lockoutTime <= 0:
		roll_dice()
		if _warrior_check():
			_doubleRoll = true
		_used = false

func roll_dice():
	_rollSound.play_from_list()
	_current_roll = dice.rollDice()
	label.text = str(dice.current_roll)

func _on_area_2d_input_event(_viewport, _event, _shape_idx):
	#implement pickup behaviour
	if Input.is_action_just_pressed("click") && !_used:
		_check_closest(false).currentNode = null
		_selected = true
	elif Input.is_action_just_pressed("click") && _used:
		_lockedSound.play_from_list()


func _lockout(_lockoutLength):
	_used = true
	# overlay.color = Color(0,0,0,0.2)
	_lockoutTime = _lockoutLength
	_lockoutBarMax = _lockoutLength
	lockoutBar.max_value = _lockoutBarMax*100
	lockoutBar.value = _lockoutBarMax*100
	

func _input(event):
	#implement dropping behaviour
	if _dam_calc == null:
		_dam_calc = get_node("/root/Main/damage_calculator")
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and not event.pressed and not _used:
			if _closest_target != null:
				_dam_calc.attack(dice, _closest_target)
				_attackSound.play_from_list()
				_closest_target = null
				for child in _target_nodes:
					child.deselect()
				if !_warrior_check() || (_warrior_check() && !_doubleRoll):
					_lockout(dice.lockout_time())
				else:
					_doubleRoll = false
					roll_dice()
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

func upgrade() -> bool:
	var _upgradable: bool = dice.upgrade()
	if _upgradable:
		set_image()
		return true
	else:
		print("Cannot upgrade further")
		return false

func changeClass(diceRole: dice_stats.diceClass, roleImage: Texture2D) -> bool:
	print('Updating class')
	if dice.role == diceRole:
		print("failed")
		return false
	else:
		dice.role = diceRole
		dice_class_image.texture = roleImage
		set_image()
		print("success")
		return true

func set_image():
	for output in images.diceSet:
		if output.type == dice.type && output.role == dice.role:
			$Sprite2D.texture = output.default_image

func _warrior_check() -> bool:
	if dice.role == dice_stats.diceClass.Warrior:
		return true
	else:
		return false

func reduce_lockout() -> void:
	_lockoutTime -= 100
	if _lockoutTime == 0:
		_lockoutTime = 0

func refresh_lockout() -> void:
	_lockoutTime = 0