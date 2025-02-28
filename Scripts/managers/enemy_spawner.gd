extends Node
class_name spawner


@onready var enemy_walker_scene = preload("res://Scenes/enemy_walker.tscn")
@onready var enemy_wagon_scene = preload("res://Scenes/enemy_wagon.tscn")
@export var spawn_parent: Node
@export var tim_con: game_controller
@export var _spawn_area: Control
@export var _end_area: Control
# @export var lanes: int = 8
# @export var ranks: int = 9
@export var card_sprite_sheet: Texture2D
@export var default_scale: float = 1
@export var grow_on_approach:= false
@export var growth_per_step:= 1.1
var _card_list: card_images
var _card_list_res = preload("res://Scripts/resources/card_image_dict.gd")


func _ready():
	get_tree().root.size_changed.connect(resize)

	_card_list = _card_list_res.new()
	_card_list.create_deck(card_sprite_sheet)
	connect_signals()

func connect_signals():
	signals.game_over.connect(restart)

func spawn_enemies(row_info: pregenerated_wave) -> void:
	for n in row_info.wave.size():
		if row_info.wave[n].type == enemy.types.none:
			continue
		var enemy_object: Object
		match row_info.wave[n].type:
			enemy.types.card:
				enemy_object = spawn_card(row_info.wave[n])
			enemy.types.wagon:
				enemy_object = spawn_wagon(row_info.wave[n])
		var x = n
		var y = _spawn_area.global_position.y
		enemy_object.gridPosition = Vector2(x,0)
		enemy_object.global_position = Vector2(grid_to_global(Vector2(x,0)).x,y - ((_spawn_area.size.y / stats.lanes)*3))
		enemy_object.spawnTarget = grid_to_global(enemy_object.gridPosition)
		sort_children()

func spawn_card(enemyID: enemy_identifier) -> Object:
	var instance = enemy_walker_scene.instantiate()
	spawn_parent.add_child(instance)
	instance.spawn(_card_list.specific_card(enemyID.identifier))
	_set_variables(instance)
	return instance

func spawn_wagon(enemyID: enemy_identifier) -> Object:
	var instance = enemy_wagon_scene.instantiate()
	spawn_parent.add_child(instance)
	instance.spawn(enemyID.identifier)
	_set_variables(instance)
	return instance


func _set_variables(obj: Object):
	obj.global_scale *= default_scale
	obj.growthPerStep = growth_per_step
	obj.grow_on_approach = grow_on_approach


func _move_enemies() -> void:
	if spawn_parent.get_child_count() > 0:
		for child in spawn_parent.get_children():
			child.gridPosition = Vector2(child.gridPosition.x, child.gridPosition.y+1)
			var gridPosition = child.gridPosition
			child.move(grid_to_global(gridPosition))
			child.danger_check(stats.ranks-1)
	game_over_check()

func _reposition_enemies() -> void:
	for child in spawn_parent.get_children():
		var gridPosition = child.gridPosition
		child.move(grid_to_global(gridPosition))

func restart() -> void:
	for child in spawn_parent.get_children():
		child.queue_free()

func resize() -> void:
	_reposition_enemies()
	
func grid_to_global(coordinates: Vector2) -> Vector2:
	var percent_x = coordinates.x / stats.lanes
	# var percent_y = coordinates.y / stats.ranks
	var startPos: Vector2
	var endPos: Vector2
	var output = Vector2.ZERO
	startPos.x = _spawn_area.global_position.x + ((_spawn_area.size.x / stats.lanes)*coordinates.x) + ((_spawn_area.size.x / stats.lanes)/2)
	endPos.x = _end_area.global_position.x + ((_end_area.size.x / stats.lanes) * coordinates.x)+ ((_spawn_area.size.x / stats.lanes)/2)
	startPos.y = _spawn_area.global_position.y
	endPos.y = _end_area.global_position.y + _end_area.size.y

	var laneHeight = (endPos.y - startPos.y) / stats.ranks

	output.x = startPos.x + ((endPos.x - startPos.x)*percent_x)
	output.y = startPos.y + (laneHeight*coordinates.y)+ (laneHeight/2)
	return output

func game_over_check():
	for child in spawn_parent.get_children():
		if child.game_over_check(stats.ranks-1):
			signals.emit_game_over()

func sort_children():
	var count = spawn_parent.get_child_count()
	for n in count:
		spawn_parent.get_child(count-1-n).z_index = 0 + n
		