extends Node
class_name spawner


@onready var enemy_walker = preload("res://Scenes/enemy_walker.tscn")
@export var spawn_parent: Node
@export var tim_con: game_controller
@export var _spawn_area: Control
@export var _end_area: Control
@export var lanes: int = 8
@export var ranks: int = 9
@export var card_sprite_sheet: Texture2D
@export var default_scale: float = 1
@export var grow_on_approach:= false
@export var growth_per_step:= 1.1
var _card_list: card_images
var _card_list_res = preload("res://Scripts/card_image_dict.gd")
var _allPositions = []

func _ready():
	get_tree().root.size_changed.connect(resize)
	_prepare_enemy_map()
	_card_list = _card_list_res.new()
	_card_list.create_deck(card_sprite_sheet)
	connect_signals()

func connect_signals():
	signals.game_over.connect(restart)

func spawn_enemies(row_info: Array[int]) -> void:
	_grid_check()
	for n in row_info.size():
		if row_info[n] == 0:
			continue
		var instance = enemy_walker.instantiate()
		spawn_parent.add_child(instance)
		var x = n
		var y = _spawn_area.global_position.y
		instance.gridPosition = Vector2(x,0)
		instance.global_position = Vector2(_allPositions[x][0].x,y-((_spawn_area.size.y/ranks)*2))
		instance.spawnTarget = _allPositions[x][0]
		instance.spawn(_card_list.specific_card(row_info[n]))
		instance.global_scale *= default_scale
		instance.growthPerStep = growth_per_step
		instance.grow_on_approach = grow_on_approach
		sort_children()

func _move_enemies() -> void:
	if spawn_parent.get_child_count() > 0:
		for child in spawn_parent.get_children():
			child.gridPosition = Vector2(child.gridPosition.x, child.gridPosition.y+1)
			var gridPosition = child.gridPosition
			child.move(_allPositions[gridPosition.x][gridPosition.y])
			child.danger_check(ranks-1)
	game_over_check()

func _reposition_enemies() -> void:
	for child in spawn_parent.get_children():
		var gridPosition = child.gridPosition
		child.move(_allPositions[gridPosition.x][gridPosition.y])

func restart() -> void:
	for child in spawn_parent.get_children():
		child.queue_free()

func resize() -> void:
	_prepare_enemy_map()
	_reposition_enemies()

func _grid_check() -> void:
	if _allPositions == null || _allPositions.is_empty() || _allPositions[0][0] == Vector2.ZERO:
		_prepare_enemy_map()

## Sets grid to be nested list. [lane][rank]
func _prepare_enemy_map() -> void:
	var _spawnSize = _spawn_area.size.x / lanes
	var _endSize = _end_area.size.x / lanes
	var _startPositions: Array[Vector2] = []
	var _endPositions: Array[Vector2] = []
	_startPositions.resize(lanes)
	_endPositions.resize(lanes)
	for n in lanes:
		var x_spawn = (_spawn_area.global_position.x +(n*_spawnSize + _spawnSize/2))
		_startPositions[n] = Vector2(x_spawn, _spawn_area.global_position.y)
		var x_end = (_end_area.global_position.x + (n*_endSize + _endSize/2))
		_endPositions[n] = Vector2(x_end, (_end_area.global_position.y + _end_area.size.y))
	var pos_matrix = []
	pos_matrix.resize(_startPositions.size())
	for n in _startPositions.size():
		var _pointsInLane = []
		var _distance: float = _startPositions[n].distance_to(_endPositions[n])
		var _distancePerPoint = _distance / ranks
		var _direction = _startPositions[n].direction_to(_endPositions[n])
		for x in ranks:
			_pointsInLane.append(_startPositions[n] + (_direction * _distancePerPoint * x))
		pos_matrix[n] = _pointsInLane
	_allPositions = pos_matrix

func game_over_check():
	for child in spawn_parent.get_children():
		if child.game_over_check(ranks-1):
			signals.emit_game_over()

func sort_children():
	for n in spawn_parent.get_child_count():
		spawn_parent.get_child(n).z_index = 0- n
		