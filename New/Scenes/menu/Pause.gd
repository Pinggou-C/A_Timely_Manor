extends Control

var paused = false

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	OS.set_window_size(Global_Settings.Resolution)
	

func _input(event):
	if Input.is_action_just_pressed("ui_cancel"):
		pause()

func pause():
	if paused == false:
		get_tree().paused = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		paused = true
		visible = true
	elif paused == true:
		get_tree().paused = false
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		paused = false
		visible = false

func _on_Resume_pressed():
	pause()


func _on_Main_menu_pressed():
	LevelLoader.save()
	visible = false
	get_tree().set_current_scene(Global_Variables.menu)
	Global_Variables.current = "menu"
	pause()
	Global_Variables.menu.pause(false)
	get_parent().queue_free()


func _on_Save_and_Quit_button_up():
	$confirm.popup()
	


func _on_confirm_confirmed():
	get_tree().notification(MainLoop.NOTIFICATION_WM_QUIT_REQUEST)
