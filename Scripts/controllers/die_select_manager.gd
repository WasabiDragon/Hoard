extends Node
class_name die_selector

@export var tray: dice_tray
@export var dice_parent: dice_spawner
var selected_die
var selected_die_num:=0
var override = false

func _ready():
	signals.select_next_dice.connect(_next_die)

func _input(event):
	if event.is_action_pressed("select_die"):
		var key_num = 0
		match event.keycode:
			KEY_1:
				key_num = 1
			KEY_2:
				key_num = 2
			KEY_3:
				key_num = 3
			KEY_4:
				key_num = 4
			KEY_5:
				key_num = 5
			KEY_6:
				key_num = 6
			KEY_7:
				key_num = 7
			KEY_8:
				key_num = 8
			_: 
				key_num = 0
		_find_and_select(key_num)

func _find_and_select(dieNum):
	if !globals.game_running && !override:
		return
	var active_dice:= dice_parent.get_child_count()
	if dieNum > active_dice || dieNum <= 0:
		print("deselecting all dice")
		deselect_all()
	else:
		_select(dieNum)

func deselect_all():
	if selected_die != null:
		selected_die.deselect()
	for slot in tray.slots:
		slot.deselect()
	for die in get_tree().get_nodes_in_group("dice"):
		die.selected = false
	globals.dice_selected = false
	signals.emit_die_select_changed()

## uses 1 as base, not 0 to match the on-screen prompts
func _select(dieNum):
	deselect_all()
	var to_select = dice_parent.get_child(dieNum-1)
	if selected_die == to_select:
		selected_die = null
		selected_die_num = 0
		signals.emit_die_select_changed()
		return
	selected_die_num = dieNum
	selected_die = to_select
	selected_die.selected = true
	tray.slots[dieNum-1].select(selected_die._role_mgr.get_role_color(selected_die.dice.role))
	globals.dice_selected = true
	signals.emit_die_select_changed()

func select_from_die(obj: dice_object):
	var die_num = dice_parent.get_children().find(obj)
	print("Selecting dice %d"%[die_num])
	_select(die_num+1)

func _next_die():
	if selected_die == null:
		return
	var other_dice_available = false
	for die in dice_parent.get_children():
		if !die.locked_out:
			other_dice_available = true
	if !other_dice_available:
		return
	selected_die_num += 1
	if selected_die_num > dice_parent.get_child_count():
		selected_die_num -= dice_parent.get_child_count()
	if dice_parent.get_child(selected_die_num-1).locked_out:
		_next_die()
	else:
		_select(selected_die_num)

func grabbing_other_die() -> bool:
	var dice_group = get_tree().get_nodes_in_group("dice")
	for die in dice_group:
		if die._grabbed:
			return true
	return false

func get_selected_die() -> Node:
	return selected_die