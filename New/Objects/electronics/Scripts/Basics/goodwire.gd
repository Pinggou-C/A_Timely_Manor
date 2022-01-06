extends Spatial

var frontnode = null
var rearnode = null


var connected_to_battery = "not"

var posbattery = false
var negbattery = false

var volts = 0
var amps = 0
var error = null
var flowing = false

var front_is_battery = false
var rear_is_battery = false

var front = null
var rear = null

var nodesidefront = null
var nodesiderear = null

var pickedupfront=false
var pickeduprear=false

var front_not_connected = false
var rear_not_connected = false

export (Material) var new_material

func _ready():
	#creates meshes and collisionshaped to prefent shapecopying by other wires
	var myMesh = MeshInstance.new()
	myMesh.mesh = CubeMesh.new()
	myMesh.mesh.size = Vector3(0.01, 0.01, 0.01)
	myMesh.set_surface_material(0, new_material)
	add_child(myMesh)
	var myMesh2 = MeshInstance.new()
	myMesh2.mesh = CubeMesh.new()
	myMesh2.mesh.size = Vector3(0.01, 0.01, 0.01)
	myMesh2.set_surface_material(0, new_material)
	add_child(myMesh2)
	var myMesh3 = MeshInstance.new()
	myMesh3.mesh = CubeMesh.new()
	myMesh3.mesh.size = Vector3(0.01, 0.01, 0.01)
	myMesh3.set_surface_material(0, new_material)
	add_child(myMesh3)
	var mycoll1 = StaticBody.new()
	mycoll1.add_to_group("wire")
	add_child(mycoll1)
	var mycol = CollisionShape.new()
	mycol.shape = BoxShape.new()
	mycol.shape.extents = Vector3(0.01, 0.01, 0.01)
	mycoll1.add_child(mycol)
	mycoll1.set_collision_layer_bit(0, false)
	mycoll1.set_collision_layer_bit(1, true)
	mycoll1.set_collision_layer_bit(7, true)
	mycoll1.add_to_group("wirebit")
	mycoll1.set_collision_layer_bit(3, true)
	var mycoll2 = StaticBody.new()
	mycoll2.add_to_group("wire")
	add_child(mycoll2)
	var mycol1 = CollisionShape.new()
	mycol1.shape = BoxShape.new()
	mycol1.shape.extents = Vector3(0.01, 0.01, 0.01)
	mycoll2.add_child(mycol1)
	mycoll2.set_collision_layer_bit(0, false)
	mycoll2.set_collision_layer_bit(1, true)
	mycoll2.set_collision_layer_bit(7, true)
	mycoll2.add_to_group("wirebit")
	mycoll2.set_collision_layer_bit(3, true)
	var mycoll3 = StaticBody.new()
	mycoll3.add_to_group("wire")
	add_child(mycoll3)
	var mycol2 = CollisionShape.new()
	mycol2.shape = BoxShape.new()
	mycol2.shape.extents = Vector3(0.01, 0.01, 0.01)
	mycoll3.add_child(mycol2)
	mycoll3.set_collision_layer_bit(0, false)
	mycoll3.add_to_group("wirebit")
	mycoll3.set_collision_layer_bit(1, true)
	mycoll3.set_collision_layer_bit(7, true)
	mycoll3.set_collision_layer_bit(3, true) 
	if front == null:
		front = $front.get_global_transform().origin
	if rear == null:
		rear = $rear.get_global_transform().origin
	print('create')
	resize()
#code in the wires is only called from th nodes
#calling functions in nodes is not neccesairy appart from certain situations, such as when a new nodes is created or when a node is changed

#when replacing a node with another one
func connect_to_node(newnode, oldnode):
	pass
	if frontnode == oldnode:
		frontnode = newnode
		front = frontnode.get_global_transform().origin 
		frontnode.conn(self, rearnode)
	elif rearnode == oldnode:
		rearnode = newnode
		rear = rearnode.get_global_transform().origin 
		rearnode.conn(self, frontnode)
	pass
#function for when the wire needs a new node
#also splits the wire the node gets put on
func newnode(pos, otherwire,frontback, time = "perm"):
	#loads and adds new node to scene
	if get_parent().nodes > 0 && get_parent().wires > 0:
		get_parent().nodes -= 1
		get_parent().wires -= 1
		get_tree().call_group("player","nod",1, "rem")
		get_tree().call_group("player","wir",1, "rem")
		var newnode = load("res://Objects/electronics/Items/Basics/wirenode.tscn")
		var newnode2 = newnode.instance()
		newnode2.time = "temp"
		get_parent().add_child(newnode2)
		if time == "temp":
			newnode2.temp()
		else: 
			newnode2.perm()
		newnode2.global_transform.origin = pos
		var node
		if frontback == "front":
			node = rearnode
			frontnode = newnode2
		else:
			node = frontnode
			rearnode = newnode2
		var newpos = newnode2.conn(self, node, frontback)
		var newpostrue = newpos[0]
		if frontback == "front":
			front = newpostrue
			$front.snappos = newpostrue
			nodesidefront = newpos[1]
			$front.targetpos = newpos[0]
			$front.snap_to_node = true
			$front.snapnode = newnode2
		else:
			rear = newpostrue
			$rear.snappos = newpostrue
			nodesiderear = newpos[1]
			$rear.targetpos = newpos[0]
			$rear.snap_to_node = true
			$rear.snapnode = newnode2
		otherwire.get_parent().split(newnode2)
	else:
		if get_parent().nodes < 1:
			get_tree().call_group("createui","blink",'nodes')
		if get_parent().wires < 1:
			get_tree().call_group("createui","blink",'wires')

func discon_node(node):
	if node == frontnode:
		frontnode = null
		nodesidefront = null
		front_is_battery = false
		front_not_connected = false
		$front.snappos = Vector3(0, 0, 0)
		$front.targetpos = Vector3()
		$front.snap_to_node = false
		$front.snapnode = null
		if rearnode != null:
			rearnode.disconenct_node(node)
	elif node == rearnode:
		rearnode = null
		nodesiderear = null
		rear_is_battery = false
		rear_not_connected = false
		$rear.snappos = Vector3(0, 0, 0)
		$rear.targetpos = Vector3()
		$rear.snap_to_node = false
		$rear.snapnode = null
		if frontnode != null:
			frontnode.disconenct_node(node)

func removenode(node, rearfront, delete = false):
	if delete == false:
		node.disconnect_wire(self)
		if rearfront == "front":
			frontnode = null
			if rearnode != null:
				rearnode.disconnect_node(node)
				node.disconnect_node(rearnode)
		elif rearfront == "rear":
			rearnode = null
			if frontnode != null:
				frontnode.disconnect_node(node)
				node.disconnect_node(frontnode)
	else:
		node.disconnect_wire(self, true)
		if rearfront == "front":
			frontnode = null
			if rearnode != null:
				rearnode.disconnect_node(node)
		elif rearfront == "rear":
			rearnode = null
			if frontnode != null:
				frontnode.disconnect_node(node)
		node.disconnect_all()

#splits a wire in 2
func split(node):
	#makes new wire
	var newwire = load("res://Objects/electronics/Items/Basics/goodwire.tscn")
	var newwire2 = newwire.instance()
	get_parent().add_child(newwire2)
	var rear_node = rearnode
	#new wires front, and rearnode
	var poss
	var poss2
	#gets the frontnode if it has that and gets the position the rear should have
	if frontnode != null:
		newwire2.frontnode = frontnode
		if front_is_battery:
			frontnode.conn(self, node)
		else:
			frontnode.conn(newwire2, node, "front")
		poss = node.conn(newwire2, frontnode, "rear")
	else:
		poss = node.conn(newwire2, null, "rear")
	#gets the rearnode if it has that and gets the position the fron should have
	if rearnode != null:
		if front_is_battery:
			rearnode.conn(self, node)
		else:
			rearnode.conn(self, node, "rear")
		poss2 = node.conn(self, frontnode, "front")
	else:
		poss2 = node.conn(self, null, "front")
		#resizes and sets positions
	var goodpos = poss[0]
	var goodpos2 = poss2[0]
	nodesidefront = poss2[1]
	newwire2.nodesiderear = poss[1]
	newwire2.rear = goodpos
	newwire2.front = front
	newwire2.rearnode = node
	frontnode = node
	front = goodpos2
	rear = rear
	print("rear")
	print(newwire2.rear)
	print("front")
	print(newwire2.front)
	resize()
	#newwire2.discon(true)
	newwire2.resize()

#connects a node to the wire
#front

func connect_node_front(node, pos):
	frontnode = node
	front = pos
	if rearnode != null:
		rearnode.con_node(node, self, false)
		node.con_node(rearnode, self, false)
	resize()

func disconnect_node(node, frontback):
	if frontback == "front":
		frontnode =null
		node.disconnect_node(rearnode)
		node.disconnect_wire(self)
		if rearnode != null:
			rearnode.disconnect_node(node)
	else:
		rearnode = null
		node.disconnect_node(frontnode)
		node.disconnect_wire(self)
		if frontnode != null:
			frontnode.disconnect_node(node)

#rear
func connect_node_rear(node, pos):
	rearnode = node
	rear = pos
	if frontnode != null:
		frontnode.con_node(node, self, false)
		node.con_node(frontnode, self, false)
	resize()
	
#when a node is put in the middle of the wire it splits it up
func resize_node(node, pos):
	frontnode = node
	front = pos
	resize()

func combine(otherwire, which, which2):
	var pos
	var frontnodee = otherwire.frontnode
	var rearnode1 = otherwire.rearnode
	if which2 == "rear":
		if which == "back":
			print("i")
			rear = otherwire.front
			rearnode = frontnodee
			if frontnodee != null:
				print("i2")
				frontnodee.disconnect_wire(otherwire)
				pos = frontnodee.conn(self, frontnode, "rear")
		elif which == "front":
			print("y")
			rear = otherwire.rear
			rearnode = rearnode1
			if rearnode1 != null:
				print("y2")
				rearnode1.disconnect_wire(otherwire)
				pos = rearnode1.conn(self, frontnode, "rear")
		print(pos)
		print(otherwire)
		print(otherwire.frontnode)
		print(otherwire.rearnode)
		var truepos = pos[0]
		#$rear.targetpos = truepos
		#$rear.snap_to_node = true
		#if which == "front":
		#	$rear.snapnode = rearnode1
		#elif which == "rear":
		#	$rear.snapnode = frontnodee
	if which2 == "front":
		if which == "back":
			front = otherwire.front
			frontnode = frontnodee
			if frontnodee != null:
				frontnodee.disconnect_wire(otherwire)
				pos = frontnodee.conn(self, rearnode, "front")
		elif which == "front":
			front = otherwire.rear
			frontnode = rearnode1
			if rearnode1 != null:
				rearnode1.disconnect_wire(otherwire)
				pos = rearnode1.conn(self, rearnode, "front")
		var truepos = pos[0]
		#$front.targetpos = truepos
		#$front.snap_to_node = true
		#if which == "front":
		#	$front.snapnode = rearnode1
		#elif which == "rear":
		#	$front.snapnode = frontnodee
	$front.global_transform.origin = front
	$front.snappos = front
	$frontarea.global_transform.origin = front
	$rear.global_transform.origin = rear
	$reararea.global_transform.origin = rear
	if frontnodee != null:
		frontnodee.wire(self, rearnode)
	otherwire.queue_free()
	resize()
	#resize()

#generates wire
func resize():
	var x = abs(rear.x - front.x)
	var z = abs(rear.z - front.z)
	var y = abs(rear.y - front.y)
	var y1 =Vector3(0.05, y, 0.05)
	var x1 = Vector3(x, 0.05, 0.05)
	var z1 = Vector3(0.05, 0.05, z)
	var wire1 = get_child(4)
	var wire2 = get_child(5)
	var wire3 = get_child(6)
	var wirecoll1 = get_child(7).get_child(0)
	var wirecoll2 = get_child(8).get_child(0)
	var wirecoll3 = get_child(9).get_child(0)
	if x > z && x > y:
		wire1.mesh.size = x1
		wirecoll1.shape.extents = x1 /2
		wire1.global_transform.origin = Vector3(-(rear.x - front.x)/ 2+rear.x, rear.y, rear.z)
		wirecoll1.global_transform.origin = wire1.get_global_transform().origin
		wire2.mesh.size = z1
		wirecoll2.shape.extents = z1 / 2
		wire2.global_transform.origin = Vector3(-(rear.x - front.x)+rear.x, rear.y, -(rear.z - front.z) / 2 + rear.z)
		wirecoll2.global_transform.origin = wire2.get_global_transform().origin
		wire3.mesh.size = y1
		wirecoll3.shape.extents = y1 / 2
		wire3.global_transform.origin = Vector3(-(rear.x - front.x)+rear.x, -(rear.y - front.y) / 2 + rear.y, -(rear.z - front.z) + rear.z)
		wirecoll3.global_transform.origin = wire3.get_global_transform().origin
	elif z > x && z > y:
		wire1.mesh.size = z1
		wirecoll2.shape.extents = z1 / 2
		wire1.global_transform.origin =Vector3(rear.x, rear.y, -(rear.z - front.z)/ 2 + rear.z)
		wirecoll2.global_transform.origin = wire1.get_global_transform().origin
		wire2.mesh.size = x1
		wirecoll1.shape.extents = x1 /2
		wire2.global_transform.origin = Vector3(-(rear.x - front.x) / 2 + rear.x, rear.y, -(rear.z - front.z)+rear.z)
		wirecoll1.global_transform.origin = wire2.get_global_transform().origin
		wire3.mesh.size = y1
		wirecoll3.shape.extents = y1 / 2
		wire3.global_transform.origin = Vector3(-(rear.x - front.x)+rear.x, -(rear.y - front.y) / 2 + rear.y, -(rear.z - front.z) + rear.z)
		wirecoll3.global_transform.origin = wire3.get_global_transform().origin
	else:
		wire1.mesh.size = y1
		wirecoll3.shape.extents = y1 / 2
		wire1.global_transform.origin =Vector3(rear.x, -(rear.y - front.y)/ 2 + rear.y, rear.z)
		wirecoll3.global_transform.origin = wire1.get_global_transform().origin
		wire2.mesh.size = x1
		wirecoll1.shape.extents = x1 /2
		wire2.global_transform.origin = Vector3(-(rear.x - front.x) / 2 + rear.x, -(rear.y - front.y) + rear.y, rear.z)
		wirecoll1.global_transform.origin = wire2.get_global_transform().origin
		wire3.mesh.size = z1
		wirecoll2.shape.extents = z1 / 2
		wire3.global_transform.origin = Vector3(-(rear.x - front.x)+rear.x, -(rear.y - front.y) + rear.y, -(rear.z - front.z) / 2 + rear.z)
		wirecoll2.global_transform.origin = wire3.get_global_transform().origin
	$rear.global_transform.origin = rear
	$front.global_transform.origin = front
	$reararea.global_transform.origin = rear
	$frontarea.global_transform.origin = front


func discon(booll):
	if booll == true:
		print("dis")
		get_child(7).get_child(0).disabled = true
		get_child(8).get_child(0).disabled = true
		get_child(9).get_child(0).disabled = true
	else: 
		get_child(7).get_child(0).disabled = false
		get_child(8).get_child(0).disabled = false
		get_child(9).get_child(0).disabled = false


func battery(battery, frontback):
	if frontback == "front":
		frontnode = battery
		front_is_battery = true
		if rearnode != null:
			rearnode.con_node(battery, self, true)
			battery.start_connecting()
	elif frontback == "rear":
		rearnode = battery
		rear_is_battery= true
		if frontnode != null:
			print(frontnode)
			frontnode.con_node(battery, self, true)
			battery.start_connecting()

func change_size(node, pos):
	if node == frontnode:
		front = pos
		$front.global_transform.origin = pos
		$front.targetpos = pos
		$frontarea.global_transform.origin = pos
		resize()
	elif node == rearnode:
		rear = pos
		$rear.global_transform.origin = pos
		$rear.targetpos = pos
		$frontarea.global_transform.origin = pos
		resize()

func not_connecting(battery):
	if frontnode == battery:
		front_not_connected = true
	elif rearnode == battery:
		rear_not_connected = true

func connect_start():
	front_not_connected = false
	rear_not_connected = false

func get_info():
	if error == null:
		return(["wire", false, volts, amps, 0, error, flowing])
	else:
		return(["wire", true, volts, amps, 0, error, flowing])

func pickedup(picked):
	if picked == true:
		get_child(7).get_child(0).disabled = true
		get_child(8).get_child(0).disabled = true
		get_child(9).get_child(0).disabled = true
	elif picked == false:
		get_child(7).get_child(0).disabled = false
		get_child(8).get_child(0).disabled = false
		get_child(9).get_child(0).disabled = false

func voltsamps(amp, volt, node, replace = true, clear = false):
	if replace == false:
		volts = ((volt*amp)+(volts*amps)) / (amps + amp)
		amps+= amp
	else:
		volts = volt
		amps = amp
	if clear == false:
		if node == rearnode:
			rearnode.voltsamps(amps, volts, self)
		elif node == frontnode:
			frontnode.voltsamps(amps, volts, self)

func negbattery(onof, node, path = []):
	if onof == true:
		if node == rearnode:
			negbattery = rearnode
		elif node == frontnode:
			negbattery = frontnode
	else:
		negbattery = null

func posbattery(onof, node, paths = [[]]):
	if onof == true:
		if node == rearnode:
			posbattery = rearnode
		elif node == frontnode:
			negbattery = frontnode
	else:
		posbattery = null

func delete():
	print("i")
	if rearnode != null:
		rearnode.disconnect_wire(self)
		if frontnode != null:
			rearnode.disconnect_node(frontnode)
	if frontnode != null:
		frontnode.disconnect_wire(self)
		if frontnode != null:
			frontnode.disconnect_node(rearnode)
	rearnode = null
	frontnode = null
	queue_free()
