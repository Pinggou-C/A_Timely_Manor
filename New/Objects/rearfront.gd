extends KinematicBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func pickup():
	pass
func drop(w1, w2):
	get_parent().front = get_parent().get_child(0).translation
	get_parent().rear = get_parent().get_child(1).translation
	get_parent().resize()
