extends KinematicBody

var connected = false
var pickedup = false
var oldpos
var which = null
var whichbody = null
var snappos = Vector3(0, 0, 0)

var disconpickup
var discon
var conpickup
var con
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	oldpos = get_global_transform().origin


func _physics_process(delta):
	if oldpos != get_global_transform().origin:
		get_parent().front = get_global_transform().origin
		get_parent().resize()
		oldpos = get_global_transform().origin


func pickup():
	pickedup = true
	get_parent().pickedupfront = true


func drop(w1, w2):
	if discon != null:
		if disconpickup == "end":
			pass
		elif disconpickup == "node":
			connected = null
	if con != null:
		if conpickup == "wire":
			var g = is_not_in_node(con, "wire")
			if g == true:
				get_parent().newnode(get_global_transform().origin, con, "front")
		elif conpickup == "end":
			var gg = "back"
			if con.is_in_group("wire_front_end"):
				gg = "front"
			get_parent().combine(con.get_parent(), gg, "front")
			which = null
			whichbody = null
		elif conpickup == "node":
			var go = con.enter(self)
			
	pickedup = false
	get_parent().pickedupfront = true
	get_parent().front = get_global_transform().origin
	get_parent().resize()
	if which != null:
		get_parent().combine(whichbody.get_parent(), which, "front")
		which = null
		whichbody = null
	if snappos != Vector3(0, 0, 0):
		global_transform.origin = snappos
		get_parent().front = snappos
		get_parent().resize()
	


func _on_frontarea_body_entered(body, bypas = false):
	if pickedup == true || bypas == true:
		var continu = false
		for i in get_parent().get_children():
			if i == body && continu == false:
				continu = true
		if body != get_parent().get_child(1) && body != get_parent().get_child(3) && continu == false:
			if body.is_in_group("wire"):
				if get_parent().frontnode == null:
					var g = is_not_in_node(body, "wire")
					if g == true:
						get_parent().newnode(get_global_transform().origin, body, "front")
						print('giiS')
				else:
					conpickup = 'wire'
					con = body
			elif body.is_in_group("wire_nodes"):
				if body.is_in_group("wire_end"):
					if get_parent().frontnode == null:
						which = "back"
						if body.is_in_group("wire_front_end"):
							which = "front"
						whichbody = body
					else:
						con = body
						conpickup = 'end'
				else:
					if get_parent().frontnode == null:
						var go = body.enter(self)
					else:
						con = body
						conpickup = 'node'


func _on_frontarea_body_exited(body):
	if pickedup == true:
		if body == con:
			conpickup = null
			con = null
		if body.is_in_group("wire"):
				which = null
				whichbody = null
		elif body.is_in_group("wire_nodes"):
			if body.is_in_group("wire_end"):
				pass
			else:
				pass


#checks if a body is in the wiregroup of the parents nodes
func is_not_in_node(body, type):
	var ret = false
	if type == "wire":
		if get_parent().frontnode != null:
			if !get_parent().frontnode.wires.has(body):
				if get_parent().rearnode != null:
					if !get_parent().rearnode.wires.has(body):
						ret = true
				else:
					ret = true
		if get_parent().rearnode != null:
			if !get_parent().rearnode.wires.has(body):
				if get_parent().frontnode != null:
					if !get_parent().frontnode.wires.has(body):
						ret = true
				else:
					ret = true
		if get_parent().rearnode == null && get_parent().frontnode == null:
			ret = true
	if type == "node":
		pass
	return ret
