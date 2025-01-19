extends Node2D
class_name enemy

@export var current_card_type: card_type
@export var current_hp:int = 0
@export var max_hp:int = 0
var _moving = false
var _targetPoint: Vector2
var _moveToSpawn = true
@export var spawnTarget: Vector2
@export var healthBar: ProgressBar
@export var sprite: Sprite2D
@export var animatedSprite: AnimatedSprite2D
@export var animPlayer: AnimationPlayer
@export var dangerAnimator: AnimationPlayer
var dropUpgrade: bool = false
var dropDiceClass: bool = false

func _ready():
	current_card_type = card_type.new()
	_moveToSpawn = true
	animPlayer.speed_scale = 8


func _physics_process(delta):
	if _moving:
		global_position = lerp(global_position, _targetPoint, 10*delta)
		if global_position.y >= _targetPoint.y-5:
			_moving = false
			animPlayer.play("idle")
	if _moveToSpawn:
		global_position = lerp(global_position, spawnTarget, 5*delta)
		if global_position.y >= spawnTarget.y - 5:
			_moveToSpawn = false
			animPlayer.play("idle")

func _initialize_hp():
	healthBar.value = current_hp
	healthBar.max_value = max_hp

func spawn(type: card_type):
	current_card_type = type
	if current_card_type.card_number > 10:
		var x = current_card_type.card_number
		current_hp = roundi((float(x*x) + x)/2)
		animatedSprite.animation = "boss_idle"
	else:
		current_hp = current_card_type.card_number
		animatedSprite.animation = "basic_idle"
	max_hp = current_hp
	sprite.texture = current_card_type.card_texture
	animPlayer.play("idle")
	_initialize_hp()

func damage(amount: int):
	current_hp -= amount
	healthBar.value = current_hp
	
	if current_hp <= 0:
		_death()


func _death():
	await _play_death_anim()
	queue_free()


func _play_death_anim():
	#play death animation
	#await animation finish
	#delete object
	return

func move(distance):
	_targetPoint = global_position + Vector2(0,distance)
	_moving = true
	
func danger_check(targetPos: Vector2):
	if targetPos.y <= global_position.y:
		dangerAnimator.play("danger")