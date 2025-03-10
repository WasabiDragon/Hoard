extends Node
class_name level_list_class

@export var levelInfoList: Array[level_gen_stats] = []

var levels: Array[level] = []

func _ready():
	signals.map_option_selected.connect(add_level)

func add_level(levelObj: level):
	levels.append(levelObj)