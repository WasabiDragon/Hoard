extends Label

var _moveUpBy = 200
var _targetPos: Vector2
var _go: bool = false

func set_start():
	_targetPos = Vector2(global_position.x, global_position.y-_moveUpBy)
	_go = true

func _physics_process(delta):
	if _go:
		global_position = lerp(global_position, _targetPos, 5*delta)
		if(global_position.y <= _targetPos.y+2):
			queue_free()