extends Node
class_name spawner


@onready var enemy_scene = preload("res://Scenes/enemy.tscn")
@export var spawn_parent: Node
@export var tim_con: timing_controller
@export var _spawn_area: Control
@export var lanes: int = 8
@export var ranks: int = 9
@export var card_list: card_images
@export var dead_line: Node
var _allPositions = []
var _laneSize
var _rankSize

func _ready():
	_laneSize = _spawn_area.size.x / lanes
	for n in lanes:
		_allPositions.append((n+1)*_laneSize + _laneSize/2)
	_rankSize = ((get_viewport().get_visible_rect().size.y)*0.8) / ranks
	dead_line.global_position = Vector2(dead_line.global_position.x, (_rankSize * (ranks-1))-(_rankSize/2))

func spawn_enemy(spawnedPlaces):
	var instance = enemy_scene.instantiate()
	spawn_parent.add_child(instance)
	var x = _get_new_pos(spawnedPlaces)
	instance.global_position = Vector2(x,_spawn_area.global_position.y-50)
	instance.spawnTarget = Vector2(x,_spawn_area.global_position.y+50)
	print(instance.name)
	instance.spawn(card_list.random_card())
	return x


func spawn_boss(spawnedPlaces):
	var instance = enemy_scene.instantiate()
	spawn_parent.add_child(instance)
	var x = _get_new_pos(spawnedPlaces)
	instance.global_position = Vector2(x,_spawn_area.global_position.y-50)
	instance.spawnTarget = Vector2(x,_spawn_area.global_position.y+50)
	instance.spawn(card_list.random_boss())
	return x

func _get_new_pos(spawnedPlaces):
	var x = ((randi() % lanes)*_laneSize) + _laneSize/2
	if spawnedPlaces.size() >= lanes:
		print("No more spawning possible")
		return
	else:
		while spawnedPlaces.has(x):
			x = ((randi() % lanes)*_laneSize) + _laneSize/2
	return x


func _move_enemies():
	for child in spawn_parent.get_children():
		child.move(_rankSize)
		child.danger_check(Vector2(dead_line.global_position.x, (_rankSize * (ranks-2))-(_rankSize/2)))
	tim_con.check_game_over()

func restart():
	for child in spawn_parent.get_children():
		child.queue_free()
