extends Control

var has_save = false
var saves = []
# Declare member variables here. Examples:
# var a = 2
export(PackedScene) var lev 
#var level = preload("res://Areas/completed_levels/Level1.tscn")
var returned = false

# Called when the node enters the scene tree for the first time.
func _ready():
	Global_Variables.menu = self




func _on_Quit_pressed():
	get_tree().notification(MainLoop.NOTIFICATION_WM_QUIT_REQUEST)


func _on_start_pressed():
	pause(true)
	BackgroundLoad.load_scene("res://Areas/completed_levels/demo.tscn", 0.01, true, self)

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

func load_return(reswource):
	get_tree().get_root().add_child(reswource)
	var gg = get_tree().current_scene
	get_tree().current_scene = reswource
	gg.queue_free()

