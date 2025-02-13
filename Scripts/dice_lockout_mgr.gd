extends Node
class_name dice_lockout_mgr

@export var lockoutBar: TextureProgressBar

var _lockoutBarMax: int
var _lockoutTime: float = 0
var _reducingClock: bool = false
var _used:= false

var locked_out: bool:
	get:
		return _lockoutTime > 0	

func attempt_roll() -> bool:
	if _used:
		_lockoutTime -=1
		_reducingClock = true
	if _lockoutTime <= 0:
		_used = false
		return true
	else:
		return false

func lockout(_lockoutLength):
	_used = true
	# overlay.color = Color(0,0,0,0.2)
	_lockoutTime = _lockoutLength
	_lockoutBarMax = _lockoutLength
	lockoutBar.max_value = _lockoutBarMax*100
	lockoutBar.value = _lockoutBarMax*100

func _process(_delta):
	if _reducingClock:
		lockoutBar.value = int(lerp(lockoutBar.value, _lockoutTime*100, 10*_delta))
		if(lockoutBar.value <= _lockoutTime*100+5):
			lockoutBar.value = _lockoutTime*100
			_reducingClock = false

func reduce_lockout():
	_lockoutTime -= 100
	_reducingClock = true
	if _lockoutTime == 0:
		_lockoutTime = 0
		_used = false

func refresh_lockout() -> void:
	_lockoutTime = 0
	_reducingClock = true
	_used = false