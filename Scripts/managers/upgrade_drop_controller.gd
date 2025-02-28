extends Node
class_name upgrade_drop

@onready var _upgradeScene = preload("res://Scenes/droppable_upgrade.tscn")
@export var spawn_pos: Marker2D
@export var next_round_button: Control
var _currentClassTexture: Texture2D

func drop_upgrade(texture: Texture2D):
	var instance = _upgradeScene.instantiate()
	add_child(instance)
	instance.global_position = spawn_pos.global_position
	instance.type = droppable_upgrade.upgradeType.upgrade
	instance.get_node("sprite").texture = texture
	instance.spawn()

func drop_dice_class(texture: Texture2D, role: dice_stats.diceRole):
	var instance = _upgradeScene.instantiate()
	add_child(instance)
	instance.global_position = spawn_pos.global_position
	instance.type = droppable_upgrade.upgradeType.diceClass
	instance.role = role
	instance.get_node("sprite").texture = texture
	instance.spawn()
	_currentClassTexture = texture

func drop_extra_dice():
	%dice_spawner.spawn_die()
	next_round_button.show()

func upgrade(target: Node, type: droppable_upgrade.upgradeType, _role: dice_stats.diceRole) -> bool:
	match type:
		droppable_upgrade.upgradeType.upgrade:
			next_round_button.show()
			return target.upgrade()
		droppable_upgrade.upgradeType.diceClass:
			next_round_button.show()
			return target.changeClass(_role)
	return false

func boss_upgrade():
	next_round_button.show()