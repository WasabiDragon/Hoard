extends NinePatchRect

@export var targetZone: Control

func _ready():
	call_deferred("init")
	get_tree().root.size_changed.connect(resize)

func init():
	resize()

func resize():
	var newPos: Vector2 = targetZone.global_position
	var newSize: Vector2 = targetZone.size
	newSize.y -= (targetZone.size.y / stats.ranks)
	print(newPos)
	print(newSize)
	size = newSize
	# newPos.y += (size.y / stats.ranks) * 2
	global_position = newPos