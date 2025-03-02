extends Marker2D

@export var upgrade_icon: Texture2D
@export var upgrade_icon_textures: Array[TextureRect]
@export var colorRect: ColorRect
@export var slotLabel: Label
@export var selected: Color
@export var deselected: Color = Color(0,0,0,0)

var currentNode = null:
	set(value):
		currentNode = value
var available: bool:
	get:
		return currentNode == null

func select(color: Color):
	for child in get_tree().get_nodes_in_group("zones"):
		if child.available:
			child.deselect()
	colorRect.get_parent().show()
	var new_col = color
	new_col.a = 0.4
	colorRect.color = new_col
	
func deselect():
	colorRect.get_parent().hide()
	colorRect.color = deselected

func place(dropped_node):
	currentNode = dropped_node
	# deselect()

func setup_slot(slotNum):
	slotLabel.text = str(slotNum)

## current is the amount currently owned, required is the TOTAL amount needed to leve up
func set_upgrades(current: int, required: int):
	for n in upgrade_icon_textures.size():
		if n < current:
			upgrade_icon_textures[n].show()
			upgrade_icon_textures[n].texture = upgrade_icon
			upgrade_icon_textures[n].get_child(0).hide()
		elif n < required:
			upgrade_icon_textures[n].show()
			upgrade_icon_textures[n].get_child(0).show()
		else:
			upgrade_icon_textures[n].hide()


