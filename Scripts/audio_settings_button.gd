extends TextureButton

func _ready():
	pressed.connect(toggle_menu)

func toggle_menu():
	get_child(0).visible = !get_child(0).visible