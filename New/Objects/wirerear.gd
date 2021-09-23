extends KinematicBody

var connected = false
var pickedup = false
var oldpos
var which = null
var whichbody = null
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	oldpos = get_global_transform().origin

func _physics_process(delta):
	if oldpos != get_global_transform().origin:
		get_parent().rear = get_global_transform().origin
		get_parent().resize()
	oldpos = get_global_transform().origin

func pickup():
	pickedup = true

func drop(w1, w2):
	pickedup = false
	get_parent().rear = get_global_transform().origin
	get_parent().resize()
	if which != null:
		get_parent().combine(whichbody.get_parent(), which, "rear")




func _on_reararea_body_entered(body):
	if body != get_parent().get_child(1) && body != get_parent().get_child(3) :
		if body.is_in_group("wire"):
			print("hii")
		elif body.is_in_group("wire_nodes"):
			if body.is_in_group("wire_end"):
				if body.pickedup == false:
					which = "back"
					if body.is_in_group("wire_front_end"):
						which = "front"
					whichbody = body
					print('fi')
			else:
				var go = body.enter(self)


func _on_reararea_body_exited(body):
	whichbody = null
	which = null