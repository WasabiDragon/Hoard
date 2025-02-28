extends Node
class_name signal_bus

signal refresh_all
signal roll_dice
signal all_enemies_spawned
signal turn_ended
signal restarting
signal game_start
signal music_menus
signal check_round_end
signal next_round
signal game_over
signal boss_text_complete
signal boss_fight
signal boss_complete
signal music_volume_changed
signal sfx_volume_changed
signal show_title
signal title_complete
signal audio_setup_complete
signal select_next_dice
signal quickshot

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

func emit_game_start():
	game_start.emit()

func emit_music_menus():
	music_menus.emit()

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

func emit_music_volume_changed():
	music_volume_changed.emit()

func emit_SFX_volume_changed():
	sfx_volume_changed.emit()

func emit_boss_complete():
	boss_complete.emit()

func emit_show_title(title_string: String, color: Color):
	show_title.emit(title_string, color)

func emit_title_complete():
	title_complete.emit()

func emit_audio_setup_complete():
	audio_setup_complete.emit()

func emit_select_next_dice():
	select_next_dice.emit()

func emit_quickshot():
	quickshot.emit()