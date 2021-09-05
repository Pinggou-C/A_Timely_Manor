extends Spatial


var paused = false

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	OS.set_window_size(Global_Settings.Resolution)
	

func _input(event):
	if Input.is_action_just_pressed("ui_cancel"):
		if paused == false:
			get_tree().paused = true
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			paused = true
			for i in get_tree().get_nodes_in_group("paused"):
				i.visible = true
		elif paused == true:
			get_tree().paused = false
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			paused = false
			for i in get_tree().get_nodes_in_group("paused"):
				i.visible = false
