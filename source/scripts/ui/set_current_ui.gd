class_name UIMenu
extends Control

@export var focus : Control
@export var pause_menu : bool

func _process(_delta):
	if pause_menu:
		if Input.is_action_just_pressed("pause"):
			if can_pause():
				var _visible = !visible
				if !_visible:
					for sibling in get_parent().get_children():
						if sibling == self:
							continue
						else:
							sibling.visible = false
					GameManager.paused = false
				else:
					GameManager.paused = true
					for sibling in get_parent().get_children():
						if sibling == self:
							continue
						else:
							if sibling.visible == true:
								_visible = false
								GameManager.paused = false
							sibling.visible = false
				visible = _visible

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	if visible:
		UIManager.current = self
		if focus != null:
			UIManager.current_focus = focus
			focus.grab_focus()
			focus.grab_click_focus()
		UIManager.current_viewport = get_parent()
	connect("visibility_changed", _on_visibility_changed)

func _on_visibility_changed():
	if visible:
		UIManager.current = self
		if focus != null:
			focus.grab_focus()
			focus.grab_click_focus()
		UIManager.current_viewport = get_parent()

func can_pause() -> bool:
	if GameManager.main_menu:
		return false
	return true
