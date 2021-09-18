extends KinematicBody

var connected = false
var pickedup = false
var oldpos
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	oldpos = translation
func _physics_process(delta):
	if oldpos != translation:
		get_parent().front = translation
		get_parent().rear = get_parent().get_child(3).translation
		get_parent().resize()
func pickup():
	pickedup = true
func drop(w1, w2):
	pickedup = false
	get_parent().front = translation
	get_parent().rear = get_parent().get_child(3).translation
	get_parent().resize()


func _on_frontarea_body_entered(body):
	if body.is_in_group("wire"):
		pass
	elif body.is_in_group("wire_nodes"):
		if body.is_in_group("wire_end"):
			pass
		else:
			var go = body.enter(self)


func _on_frontarea_body_exited(body):
	if body.is_in_group("wire"):
		pass
	elif body.is_in_group("wire_nodes"):
		if body.is_in_group("wire_end"):
			pass
		else:
			pass
