extends KinematicBody

var connected = false
var pickedup = false
var oldpos
var which = null
var whichbody = null
var snappos = Vector3(0, 0, 0)

var targetpos = Vector3()
var snap_to_node = false
var snapnode = null

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
	if oldpos != get_global_transform().origin && pickedup == true:
		get_parent().rear = get_global_transform().origin
		get_parent().resize()
		oldpos = get_global_transform().origin


func pickup():
	pickedup = true
	get_parent().pickeduprear = true


func drop(w1, w2):
	var parent = get_parent()
	if discon != null:
		if disconpickup == "end":
			pass
		elif disconpickup == "node":
			connected = null
	if con != null:
		if connected == null:
			if conpickup == "wire":
				var g = is_not_in_node(con, "wire")
				if g == true:
					parent.newnode(get_global_transform().origin, con, "rear")
			elif conpickup == "end":
				var gg = "front"
				if con.is_in_group("wire_front_end"):
					gg = "back"
				parent.combine(con.get_parent(), gg, "rear")
				which = null
				whichbody = null
			elif conpickup == "node":
				var go = con.conn(parent, parent.rearnode, 'rear')
				parent.connect_node_rear(con, go[0])
			
	pickedup = false
	parent.pickedupfront = true
	parent.rear = get_global_transform().origin
	parent.resize()
	if which != null:
		parent.combine(whichbody.get_parent(), which, "rear")
		which = null
		whichbody = null
	if snappos != Vector3(0, 0, 0):
		global_transform.origin = snappos
		parent.rear = snappos
		parent.resize()
	


func _on_reararea_body_entered(body, bypas = false):
	var parent = get_parent()
	if pickedup == true || bypas == true:
		var continu = false
		for i in parent.get_children():
			if i == body && continu == false:
				continu = true
		if body != parent.get_child(1) && body != parent.get_child(3) && continu == false:
			if body.is_in_group("wire"):
				if parent.rearnode == null:
					var g = is_not_in_node(body, "wire")
					if g == true:
						parent.newnode(get_global_transform().origin, body, "rear")
						print('giiS')
				else:
					conpickup = 'wire'
					con = body
			elif body.is_in_group("wire_nodes"):
				if body.is_in_group("wire_end"):
					if parent.rearnode == null:
						which = "back"
						if body.is_in_group("wire_front_end"):
							which = "front"
						whichbody = body
					else:
						con = body
						conpickup = 'end'
				else:
					if parent.rearnode == null:
						var go = body.conn(parent, parent.rearnode, 'rear', true)
						parent.connect_node_rear(body, go[0])
						targetpos = go[0]
						snap_to_node = true
						snapnode = body
					else:
						var go = body.conn(parent, parent.rearnode, 'rear', true)
						targetpos = go[0]
						snap_to_node = true
						snapnode = body
						con = body
						conpickup = 'node'
			elif body.is_in_group("battery"):
				parent.battery(body.get_parent(), "rear")


func _on_reararea_body_exited(body):
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
				if body == snapnode:
					snapnode =null
					snap_to_node = false
					targetpos = Vector3()
				get_parent().disconnect_node(body, 'rear')


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

