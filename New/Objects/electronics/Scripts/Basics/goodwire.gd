extends Spatial

var frontnode = null
var rearnode = null

var front_is_battery = false
var rear_is_battery = false

var front = null
var rear = null

var nodesidefront = null
var nodesiderear = null

var pickedupfront=false
var pickeduprear=false

func _ready():
	#creates meshes and collisionshaped to prefent shapecopying by other wires
	var myMesh = MeshInstance.new()
	myMesh.mesh = CubeMesh.new()
	myMesh.mesh.size = Vector3(0.01, 0.01, 0.01)
	add_child(myMesh)
	var myMesh2 = MeshInstance.new()
	myMesh2.mesh = CubeMesh.new()
	myMesh2.mesh.size = Vector3(0.01, 0.01, 0.01)
	add_child(myMesh2)
	var myMesh3 = MeshInstance.new()
	myMesh3.mesh = CubeMesh.new()
	myMesh3.mesh.size = Vector3(0.01, 0.01, 0.01)
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
	mycoll2.set_collision_layer_bit(3, true)
	var mycoll3 = StaticBody.new()
	mycoll3.add_to_group("wire")
	add_child(mycoll3)
	var mycol2 = CollisionShape.new()
	mycol2.shape = BoxShape.new()
	mycol2.shape.extents = Vector3(0.01, 0.01, 0.01)
	mycoll3.add_child(mycol2)
	mycoll3.set_collision_layer_bit(0, false)
	mycoll3.set_collision_layer_bit(1, true)
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
func newnode(pos, otherwire,frontback):
	#loads and adds new node to scene
	var newnode = load("res://Objects/electronics/Items/Basics/wirenode.tscn")
	var newnode2 = newnode.instance()
	get_parent().add_child(newnode2)
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
	else:
		rear = newpostrue
		$rear.snappos = newpostrue
		nodesiderear = newpos[1]
	otherwire.get_parent().split(newnode2)


func removenode(node, rearfront):
	node.disconnect_wire(self)
	if rearfront == "front":
		frontnode = null
		if rearnode != null:
			rearnode.disconnect_node(node)
			node.disconnect_node(rearnode)
	elif rearfront == "front":
		rearnode = null
		if frontnode != null:
			frontnode.disconnect_node(node)
			node.disconnect_node(frontnode)

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
		frontnode.conn(newwire2, node, "front")
		poss = node.conn(newwire2, frontnode, "rear")
	else:
		poss = node.conn(newwire2, null, "rear")
	#gets the rearnode if it has that and gets the position the fron should have
	if rearnode != null:
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
#rear
func connect_node_rear(node, pos):
	rearnode = node
	rear = pos
	
#when a node is put in the middle of the wire it splits it up
func resize_node(node, pos):
	frontnode = node
	front = pos

func combine(otherwire, which, which2):
	if which2 == "rear":
		if which == "back":
			print("bb")
			rear = otherwire.front
			rearnode = otherwire.frontnode
		elif which == "front":
			print("bf")
			rear = otherwire.rear
			rearnode = otherwire.rearnode
	if which2 == "front":
		if which == "back":
			print("fb")
			front = otherwire.front
			frontnode = otherwire.frontnode
			print(otherwire.front)
		elif which == "front":
			print("ff")
			front = otherwire.rear
			frontnode = otherwire.rearnode
	$front.global_transform.origin = front
	$front.snappos = front
	$frontarea.global_transform.origin = front
	$rear.global_transform.origin = rear
	$reararea.global_transform.origin = rear
	if otherwire.frontnode != null:
		otherwire.frontnode.wire(self, rearnode)
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
			battery.start_connecting()
	elif frontback == "rear":
		rearnode = battery
		rear_is_battery= true
		if frontnode != null:
			battery.start_connecting()
