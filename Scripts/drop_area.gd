extends Marker2D

@export var colorRect: ColorRect
var currentNode = null:
	set(value):
		currentNode = value
var available: bool:
	get:
		return currentNode == null

func select():
	for child in get_tree().get_nodes_in_group("zones"):
		if child.available:
			child.deselect()
	colorRect.color = Color(0.823, 0.322, 0.422, 0.145)
	
func deselect():
	colorRect.color = Color(0.518, 0.518, 0.518, 0.145)

func place(dropped_node):
	currentNode = dropped_node
	deselect()



