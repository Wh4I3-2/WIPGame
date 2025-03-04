extends Button

func _ready():
	connect("button_up", _on_button_up)

func _on_button_up():
	WindowManager.toggle_fullscreen()
