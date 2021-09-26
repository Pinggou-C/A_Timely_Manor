extends Control

var mai
var returned = false
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	set_physics_process(false)
	BackgroundLoad.load_scene("res://Scenes/menu/Mainmenu.tscn", 0.001, true, self)
	$Tween2.interpolate_property(self, "modulate", modulate, Color(1, 1, 1, 1), 0.3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween2.start()
	
	returned = false
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func start():
	#does the intro animation and stuff
	#tweens opacity
	$Tween.interpolate_property(self, "modulate", modulate, Color(0, 0, 0, 0), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()

func _on_Tween_tween_completed(object, key):
	#gets callled when the second tween is done
	if returned == true:
		get_tree().get_root().add_child(mai)
		get_tree().set_current_scene(mai)
		queue_free()
	set_physics_process(true)

func _on_Tween2_tween_completed(object, key):
	start()

func _physics_process(delta):
	if returned == true:
		get_tree().get_root().add_child(mai)
		get_tree().set_current_scene(mai)
		queue_free()

func load_return(scene):
	print(scene)
	mai = scene
	returned = true
