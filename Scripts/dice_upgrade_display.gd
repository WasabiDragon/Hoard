extends Control
class_name dice_upgrade_display_panel

@export var texture_rect: TextureRect
@export var accept_button: Button
@export var next_round_button: Node
@export var text: RichLabelAutoSizer
@onready var die_select: die_selector = $/root/Main/game_controller/die_select
var upgrade_type: reward_obj.reward
var saved_role: dice_stats.diceRole

var selecting = false

func _ready():
	signals.die_select_changed.connect(button_check)

func upgrade_selection(texture: Texture2D):
	texture_rect.texture = texture
	upgrade_type = reward_obj.reward.TIER_UP
	_empty_selections()
	show()
	text.text = text.text

func role_change_selction(texture: Texture2D, role: dice_stats.diceRole):
	texture_rect.texture = texture
	upgrade_type = reward_obj.reward.ROLE
	saved_role = role
	_empty_selections()
	show()
	text.text = text.text

func _empty_selections():
	accept_button.disabled = true
	die_select.override = true
	die_select.deselect_all()
	selecting = true

func button_check():
	if !selecting:
		return
	if globals.dice_selected:
		accept_button.disabled = false
	else:
		accept_button.disabled = true

func accept():
	if upgrade():
		selecting = false
		die_select.override = false
		hide()
		upgrade_complete()
	
	
func upgrade() -> bool:
	var target = die_select.get_selected_die()
	match upgrade_type:
		reward_obj.reward.TIER_UP:
			return target.upgrade()
		reward_obj.reward.ROLE:
			return target.changeClass(saved_role)
	return false

func drop_extra_dice():
	%dice_spawner.spawn_die()

func upgrade_complete():
	next_round_button.show()