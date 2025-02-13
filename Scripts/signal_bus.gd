extends Node
class_name signal_bus

signal refresh_all
signal roll_dice
signal all_enemies_spawned
signal turn_ended
signal restarting
signal music_game_start
signal music_menus
signal music_game_over
signal check_round_end
signal next_round
signal game_over
signal boss_text_complete
signal boss_fight

func emit_refresh_all():
	refresh_all.emit()

func emit_roll_dice():
	roll_dice.emit()

func emit_all_enemies_spawned():
	all_enemies_spawned.emit()

func emit_turn_ended():
	turn_ended.emit()

func emit_restarting():
	restarting.emit()

# func emit_refresh_round_tracker():
# 	refresh_round_tracker.emit()

func emit_music_game_start():
	music_game_start.emit()

func emit_music_menus():
	music_menus.emit()

func emit_music_game_over():
	music_game_over.emit()

func emit_check_round_end():
	check_round_end.emit()

func emit_next_round():
	next_round.emit()

func emit_game_over():
	game_over.emit()

func emit_boss_fight(fight_name: String):
	boss_fight.emit(fight_name)

func emit_boss_text_complete():
	boss_text_complete.emit()