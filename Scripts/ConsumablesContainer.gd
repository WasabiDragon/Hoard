extends Control

@export var targetZone: Node
@export var endTurnButton: Node

func _ready():
	resize()
	get_tree().root.size_changed.connect(resize)

func resize():
	size = Vector2(targetZone.global_position.x, endTurnButton.global_position.y)