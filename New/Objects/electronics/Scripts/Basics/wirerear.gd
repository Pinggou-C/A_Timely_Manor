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
var disconextra
var conpickup
var con
var conextra
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
	get_parent().pickedup(true)


func drop(w1, w2):
	var parent = get_parent()
	get_parent().pickedup(false)
	if discon != null:
		if disconpickup == "end":
			pass
		elif disconpickup == "node":
			connected = null
			if disconextra == "temp":
				pass
	if con != null:
		if connected == null:
			if conpickup == "wire":
				if conextra == "nodetemp":
					parent.rearnode.perm()
				else:
					var g = is_not_in_node(con, "wire")
					if g == true:
						parent.newnode(get_global_transform().origin, con, "rear")
			elif conpickup == "end":
				var gg = "back"
				if con.is_in_group("wire_front_end"):
					gg = "front"
				parent.combine(con.get_parent(), gg, "rear")
				which = null
				whichbody = null
			elif conpickup == "node":
				var go = con.conn(parent, parent.rearnode, 'rear')
				parent.connect_node_rear(con, go[0])
	if snapnode != null:
		if snapnode.time == "temp":
			snapnode.perm()
	pickedup = false
	parent.pickeduprear = true
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
						parent.newnode(get_global_transform().origin, body, "rear", "temp")
						conpickup = 'wire'
						con = body
						conextra = "nodetemp"
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
					if body.time != "temp":
						if parent.rearnode == null:
							var go = body.conn(parent, parent.rearnode, 'rear', true)
							parent.connect_node_rear(body, go[0])
							targetpos = go[0]
							snap_to_node = true
							snapnode = body
						else:
							con = body
							conpickup = 'node'
							var go = body.conn(parent, parent.rearnode, 'rear', true)
							targetpos = go[0] 
							snap_to_node = true
							snapnode = body
			elif body.is_in_group("appliance") || body.is_in_group("battery"):
				var nod = body
				var dirr = "rear"
				if body.is_in_group("battery"):
					parent.battery(body.get_parent(), "rear")
					nod = body.get_parent()
					if body.is_in_group("pos"):
						dirr = "front"
				if body.is_in_group("door"):
					nod = body.get_parent()
				if parent.rearnode == null:
					var go = nod.conn(parent, parent.rearnode, dirr, true)
					parent.connect_node_rear(body, go[0])
					targetpos = go[0]
					snap_to_node = true
					snapnode = nod
				else:
					con = body
					conpickup = 'node'
					var go = nod.conn(parent, parent.rearnode, dirr, true)
					targetpos = go[0] 
					snap_to_node = true
					snapnode = nod
					if body.is_in_group("battery") && dirr == "front":
						parent.volts = go[3]
						parent.amps = go[2]


func _on_reararea_body_exited(body):
	if pickedup == true:
		if body == con:
			conpickup = null
			con = null
		if body.is_in_group("wire"):
				which = null
				whichbody = null
		elif body.is_in_group("wire_nodes")|| body.is_in_group("appliance")|| body.is_in_group("battery"):
			var one = body
			if body.is_in_group("battery") || body.is_in_group("door"):
				one = body.get_parent()
			if body.is_in_group("wire_end"):
				pass
			else:
				if one.time != "temp":
					if one == snapnode:
						snapnode =null
						snap_to_node = false
						targetpos = Vector3()
						snappos = Vector3(0, 0, 0)
					get_parent().removenode(one, 'rear')
				else:
					if one == get_parent().rearnode:
						get_parent().removenode(one, 'rear', true)
					snapnode =null
					snap_to_node = false
					targetpos = Vector3()
					snappos = Vector3(0, 0, 0)


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


func add_snap(truefalse, node, pos):
	if truefalse == true:
		targetpos = pos 
		snap_to_node = true
		snapnode = node
	else:
		targetpos = null
		snap_to_node = false
		snapnode = null
