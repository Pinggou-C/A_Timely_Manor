extends Control

var main = preload("res://Scenes/menu/Mainmenu.tscn")
var mai
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$Tween2.interpolate_property(self, "modulate", modulate, Color(1, 1, 1, 1), 0.3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween2.start()
	mai = main.instance()


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
	get_tree().get_root().add_child(mai)
	get_tree().set_current_scene(mai)
	queue_free()

func _on_Tween2_tween_completed(object, key):
	start()
