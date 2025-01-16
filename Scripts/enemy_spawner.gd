extends Node
class_name spawner


@onready var enemy_scene = preload("res://Scenes/enemy.tscn")
@export var _spawn_parent: Node
@export var _spawn_area: Control
@export var lanes: int = 8
@export var card_list: card_images
var _allPositions = []
var _laneSize

func _ready():
	_laneSize = _spawn_area.size.x / lanes
	for n in lanes:
		_allPositions.append((n+1)*_laneSize + _laneSize/2)

func spawn_enemy(spawnedPlaces):
	var instance = enemy_scene.instantiate()
	_spawn_parent.add_child(instance)
	var x = _get_new_pos(spawnedPlaces)
	instance.global_position = Vector2(x,_spawn_area.global_position.y-50)
	instance.spawnTarget = Vector2(x,_spawn_area.global_position.y+50)
	print(instance.name)
	instance.spawn(card_list.random_card())
	return x


func spawn_boss(spawnedPlaces):
	var instance = enemy_scene.instantiate()
	_spawn_parent.add_child(instance)
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
	for child in _spawn_parent.get_children():
		child.move()

