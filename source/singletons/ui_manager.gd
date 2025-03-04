extends Node

var current = null
var last_focus : Control = null
var current_focus : Control = null
var current_viewport = null

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS

func _input(event):
	if is_ui_button_pressed(event):
		if last_focus == null:
			return
		if not is_instance_valid(last_focus):
			return
		if current_focus is InputOverlay:
			return
		if last_focus != null:
			last_focus.grab_focus()

func _process(_delta):
	if not is_instance_valid(current_viewport):
		current_viewport = null
	var viewport = current_viewport
	if viewport == null:
		viewport = get_tree().get_first_node_in_group("ui_viewport")
	var control = null
	if viewport != null:
		control = viewport.gui_get_focus_owner()
	current_focus = control
	if not control is InputOverlay:
		if control != null and is_instance_valid(control):
			if control is Button or control is Slider:
				last_focus = control

func is_ui_button_pressed(event : InputEvent):
	if event.is_action_pressed("ui_accept"): return true
	if event.is_action_pressed("ui_cancel"): return true
	if event.is_action_pressed("ui_down"): return true
	if event.is_action_pressed("ui_end"): return true
	if event.is_action_pressed("ui_focus_next"): return true
	if event.is_action_pressed("ui_focus_prev"): return true
	if event.is_action_pressed("ui_home"): return true
	if event.is_action_pressed("ui_left"): return true
	if event.is_action_pressed("ui_menu"): return true
	if event.is_action_pressed("ui_page_down"): return true
	if event.is_action_pressed("ui_page_up"): return true
	if event.is_action_pressed("ui_right"): return true
	if event.is_action_pressed("ui_select"): return true
	if event.is_action_pressed("ui_up"): return true
	return false
