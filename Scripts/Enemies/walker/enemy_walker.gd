extends enemy
class_name enemy_walker

func spawn(type: card_type):
	current_card_type = type
	if current_card_type.card_number > 10:
		var x = current_card_type.card_number
		max_hp = roundi((float(x*x) + x)/2)
		animatedSprite.animation = "boss_idle"
	else:
		max_hp = current_card_type.card_number
		animatedSprite.animation = "basic_idle"
	current_damage = 0
	sprite.texture = current_card_type.card_texture
	animPlayer.play("idle")
	_initialize_hp()

func _death():
	_play_death_anim()
	# await animPlayer.animation_finished
	signals.emit_check_round_end()
	queue_free()