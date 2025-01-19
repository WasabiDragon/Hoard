extends Node
class_name upgrade_drop

@onready var _upgradeScene = preload("res://Scenes/droppable_upgrade.tscn")
@export var spawn_pos: Marker2D
@export var start_button: TextureButton
var _currentClassTexture: Texture2D

func drop_upgrade(texture: Texture2D):
	var instance = _upgradeScene.instantiate()
	add_child(instance)
	instance.global_position = spawn_pos.global_position
	instance.type = droppable_upgrade.upgradeType.upgrade
	instance.get_node("sprite").texture = texture
	start_button.show()

func drop_dice_class(texture: Texture2D, role: dice_stats.diceClass):
	var instance = _upgradeScene.instantiate()
	add_child(instance)
	instance.global_position = spawn_pos.global_position
	instance.type = droppable_upgrade.upgradeType.diceClass
	instance.role = role
	instance.get_node("sprite").texture = texture
	start_button.show()
	_currentClassTexture = texture

func drop_extra_dice(texture: Texture2D):
	var instance = _upgradeScene.instantiate()
	add_child(instance)
	instance.global_position = spawn_pos.global_position
	instance.type = droppable_upgrade.upgradeType.extraDie
	instance.get_node("sprite").texture = texture
	start_button.show()

func upgrade(target: Node, type: droppable_upgrade.upgradeType, _role: dice_stats.diceClass = dice_stats.diceClass.Rogue) -> bool:
	match type:
		droppable_upgrade.upgradeType.upgrade:
			return target.upgrade()
		droppable_upgrade.upgradeType.diceClass:
			return target.changeClass(_role, _currentClassTexture)
		droppable_upgrade.upgradeType.extraDie:
			%dice_spawner.spawn_die()
			return true
	return false