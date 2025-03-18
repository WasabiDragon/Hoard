extends Node
class_name level_list_class

@export var levelInfoList: Array[level_gen_globals] = []
@export var boss_templates: Array[boss_template]

var levels: Array[level] = []

func _ready():
	signals.restarting.connect(reset)
	signals.map_option_selected.connect(add_level)

func add_level(levelObj: level):
	levels.append(levelObj)

func reset():
	levels = []