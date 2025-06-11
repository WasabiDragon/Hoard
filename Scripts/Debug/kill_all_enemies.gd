extends Button

func _ready():
	pressed.connect(kill_enemies)

func kill_enemies():
	for target in get_tree().get_nodes_in_group("enemy"):
		target.queue_free()
	signals.emit_check_round_end()