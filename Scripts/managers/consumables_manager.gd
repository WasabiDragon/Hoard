extends Node
class_name consumable_manager

@export var consumable_parent: Control
@onready var consumable_object_scene = preload("res://Scenes/consumable.tscn")
@export var freeze_button: Button

enum consumableType {
	KNOCKBACK,
	KILL_ALL,
	FREEZE,
	MAX_ROLL, # implemented in theory
	TIER_UP # to do
	}


var timers: Dictionary = {
	"KNOCKBACK" = 0,
	"FREEZE" = 0,
	"MAX_ROLL" = 0,
	"TIER_UP" = 0
}

func _ready():
	signals.next_round.connect(reduce_timers)
	signals.use_consumable.connect(use_consumable)

func use_consumable(obj: consumable) -> void:
	var type = obj.type
	match type:
		consumableType.KNOCKBACK:
			_use_knockback()
		consumableType.KILL_ALL:
			_use_kill_all()
		consumableType.FREEZE:
			_use_freeze()
		consumableType.MAX_ROLL:
			_use_max_rolls()
		consumableType.TIER_UP:
			_use_tier_up()
		_:
			print("No consumable type specified")
			return

func reduce_timers() -> void:
	for pair in timers.keys():
		if timers[pair] > 0:
			timers[pair] -= 1
			if timers[pair] <= 0:
				_disable_powerup(pair)

func _use_knockback() -> void:
	stats.consumable_knockback_enabled = true
	timers.KNOCKBACK = 3
	print("knockback enabled")

func _use_kill_all() -> void:
	for target in get_tree().get_nodes_in_group("enemy"):
		target.kill()

func _use_freeze() -> void:
	stats.consumable_freeze_enabled = true
	freeze_button.show()
	timers.FREEZE = 2

func _use_max_rolls() -> void:
	stats.consumable_max_rolls_enabled = true
	timers.MAX_ROLL = 10

func _use_tier_up() -> void:
	stats.consumable_tier_up_enabled = true
	timers.TIER_UP = 10

func _disable_powerup(key) -> void:
	var type = consumableType[key]
	match type:
		consumableType.KNOCKBACK:
			stats.consumable_knockback_enabled = false
		consumableType.FREEZE:
			stats.consumable_freeze_enabled = false
			freeze_button.hide()
		consumableType.MAX_ROLL:
			stats.consumable_max_rolls_enabled = false
		consumableType.TIER_UP:
			stats.consumable_tier_up_enabled = false
		_:
			return

