extends Node
class_name consumable_manager

@export var consumable_parent: Control
@onready var consumable_object_scene = preload("res://Scenes/consumable.tscn")
@export var freeze_button: Button

@export var consumable_list: Array[consumable]

enum consumableType {
	KNOCKBACK,
	KILL_ALL,
	FREEZE,
	MAX_ROLL, # implemented in theory
	TIER_UP # to do
	}

func _ready():
	signals.restarting.connect(reset)
	signals.use_consumable.connect(use_consumable)
	signals.add_consumable.connect(add_consumable)

func get_random_consumable() -> consumable:
	return consumable_list[randi() % consumable_list.size()].duplicate()

func add_consumable(obj: consumable) -> void:
	var instance = consumable_object_scene.instantiate()
	instance.set_consumable(obj)
	consumable_parent.add_child(instance)
	
func use_consumable(obj: consumable) -> void:
	if obj.uses > 0 && (obj.active && obj.type != consumableType.KILL_ALL):
		return
	var type = obj.type
	match type:
		consumableType.KNOCKBACK:
			if obj.active:
				return
			_use_knockback()
		consumableType.KILL_ALL:
			_use_kill_all()
		consumableType.FREEZE:
			if obj.active:
				return
			_use_freeze()
		consumableType.MAX_ROLL:
			if obj.active:
				return
			_use_max_rolls()
		consumableType.TIER_UP:
			if obj.active:
				return
			_use_tier_up()
		_:
			print("No consumable type specified")
			return
	obj.active = true


func _use_knockback() -> void:
	globals.consumable_knockback_enabled = true
	print("knockback enabled")

func _use_kill_all() -> void:
	for target in get_tree().get_nodes_in_group("enemy"):
		target.kill()

func _use_freeze() -> void:
	globals.consumable_freeze_enabled = true
	freeze_button.show()

func _use_max_rolls() -> void:
	globals.consumable_max_rolls_enabled = true

func _use_tier_up() -> void:
	globals.consumable_tier_up_enabled = true

func disable_powerup(key: String) -> void:
	var type = consumableType[key]
	match type:
		consumableType.KNOCKBACK:
			globals.consumable_knockback_enabled = false
		consumableType.FREEZE:
			globals.consumable_freeze_enabled = false
			freeze_button.hide()
		consumableType.MAX_ROLL:
			globals.consumable_max_rolls_enabled = false
		consumableType.TIER_UP:
			globals.consumable_tier_up_enabled = false
		_:
			return


func reset():
	for consumable_node in consumable_parent.get_children():
		consumable_node.queue_free()
	globals.consumable_knockback_enabled = false
	globals.consumable_freeze_enabled = false
	globals.consumable_max_rolls_enabled = false
	globals.consumable_tier_up_enabled = false
	freeze_button.hide()