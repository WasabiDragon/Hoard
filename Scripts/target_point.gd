extends Marker2D
class_name target_point

@export var color_rect: ColorRect

func select():
	for child in get_tree().get_nodes_in_group("targets"):
		child.deselect()
	color_rect.color = Color(0.741, 0.122, 0.145, 0.31)
	
func deselect():
	color_rect.color = Color(0.741, 0.122, 0.145, 0)
