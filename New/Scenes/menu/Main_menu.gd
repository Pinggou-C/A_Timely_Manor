extends Control

var has_save = false
var saves = []
# Declare member variables here. Examples:
# var a = 2
onready var level = preload("res://Areas/Area/Spatial.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.




func _on_Quit_pressed():
	get_tree().notification(MainLoop.NOTIFICATION_WM_QUIT_REQUEST)


func _on_start_pressed():
	var lev =  level.instance()
	get_tree().get_root().add_child(lev)
	get_tree().set_current_scene(lev)
	pause(true)

func pause(which):
	if which == true:
		visible = false
		for i in $buttons.get_children():
			i.disabled = true
	else:
		visible = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		for i in $buttons.get_children():
			i.disabled = false
