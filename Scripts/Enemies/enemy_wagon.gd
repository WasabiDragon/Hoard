extends enemy
class_name enemy_wagon

var wagon_contents: pregenerated_wave
var internal_rating:int
var spawn_diffs = [Vector2(-0.5, 0), Vector2(0,-0.5), Vector2(0.5,0)]
@export var wagon_hp:int
@export var royal_wagon_hp:int

## wagons will by default contain a random selection of cards between 1-10. Send true to spawn a Royal Wagon.
func spawn(rating: int = 0):
	if rating == 0:
		max_hp = 10
		internal_rating = 3
	elif rating == 1:
		max_hp = 20
		internal_rating = 8
	elif rating == 2:
		max_hp = 30
		internal_rating = 12
	elif rating == 3:
		max_hp = 40
		internal_rating = -1
	current_damage = 0
	animPlayer.play("idle")
	_initialize_hp()

func _death():
	var spwn = $/root/Main/game_controller/enemy_spawner
	if internal_rating == -1:
		var royals = [11,12,13]
		wagon_contents = wave_gen.select_cards([royals[randi()%3], royals[randi()%3], royals[randi()%3]])
	else:
		wagon_contents = wave_gen.get_group_by_challenge(3,internal_rating,true)
	for n in wagon_contents.wave.size():
		if wagon_contents.wave[n].identifier == 0:
			continue
		var object = spwn.spawn_card(wagon_contents.wave[n])
		object.gridPosition = gridPosition + spawn_diffs[n]
		object.global_position = global_position
		object.spawnTarget = spwn.grid_to_global(object.gridPosition)
	spwn._reposition_enemies()
	_play_death_anim()
	# await animPlayer.animation_finished
	signals.emit_check_round_end()
	queue_free()