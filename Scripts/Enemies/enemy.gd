extends Node2D
class_name enemy

enum types
{
	none = 0,
	card = 1,
	wagon = 2
}

@export var current_card_type: card_type
@export var current_damage:int = 0
@export var max_hp:int = 0
@export var spawnTarget: Vector2
@export var healthBar: ProgressBar
@export var sprite: Sprite2D
@export var animatedSprite: AnimatedSprite2D
@export var animPlayer: AnimationPlayer
@export var dangerAnimator: AnimationPlayer
@export var burn_anim: Node ## CHANGE TO ANIMATION ONCE CREATED

var _moving = false
var _targetPoint: Vector2
var _target_scale: Vector2 = Vector2.ONE
var _moveToSpawn = true
var gridPosition: Vector2
var grow_on_approach:= false
var growthPerStep:= 1.1
var c_tooltip: custom_tooltip

func _ready():
	current_card_type = card_type.new()
	c_tooltip = $Sprite2D/custom_tooltip
	_moveToSpawn = true
	animPlayer.speed_scale = 8


func _physics_process(delta):
	if _moving:
		global_position = lerp(global_position, _targetPoint, 10*delta)
		if grow_on_approach:
			global_scale = lerp(global_scale, _target_scale, 10*delta)
		if abs(global_position.y-_targetPoint.y) <= 5 && abs(global_position.x - _targetPoint.x) <= 5:
			_moving = false
			animPlayer.play("idle")
	if _moveToSpawn:
		if gridPosition.y >=1:
			_moveToSpawn = false
		global_position = lerp(global_position, spawnTarget, 5*delta)
		if global_position.distance_to(spawnTarget) <= 5:
			_moveToSpawn = false
			animPlayer.play("idle")

func _initialize_hp():
	healthBar.value = 0
	healthBar.max_value = max_hp
	update_tooltip()

func update_tooltip():
	var output = [str(max_hp-current_damage), str(max_hp)]
	c_tooltip.update_tooltip(output)

func spawn(_type):
	print("enemy spawn not implemented")
	pass

func _death():
	print("enemy death not implemented")
	pass

func enable_burn_anim(turns_to_burn):
	burn_anim.show()
	burn_anim.get_child(0).text = str(turns_to_burn)

func reduce_burn_anim(turns_to_burn):
	burn_anim.get_child(0).text = str(turns_to_burn)

func disable_burn_anim():
	burn_anim.hide()

func damage(amount: int):
	current_damage += amount
	healthBar.value = current_damage
	update_tooltip()
	if current_damage >= max_hp:
		_death()

func _play_death_anim():
	#play death animation
	#await animation finish
	#delete object
	return

func move(destination: Vector2):
	_targetPoint = destination
	if grow_on_approach:
		_target_scale = global_scale * growthPerStep
	_moving = true
	
func danger_check(maxRanks):
	if gridPosition.y >= maxRanks-1:
		dangerAnimator.play("danger")

func game_over_check(maxRanks):
	return gridPosition.y >= maxRanks
