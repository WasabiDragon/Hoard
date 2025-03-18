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
		match type.card_suit:
			card_type.suit.Spade:
				animatedSprite.animation = "basic_spades"
			card_type.suit.Club:
				animatedSprite.animation = "basic_clubs"
			card_type.suit.Diamond:
				animatedSprite.animation = "basic_diamonds"
			card_type.suit.Heart:
				animatedSprite.animation = "basic_hearts"
	current_damage = 0
	sprite.texture = current_card_type.card_texture
	animPlayer.play("idle")
	_initialize_hp()

func _death():
	_play_death_anim()
	# await animPlayer.animation_finished
	signals.emit_check_round_end()
	queue_free()