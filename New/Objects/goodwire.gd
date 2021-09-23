extends Spatial

var frontnode = null
var rearnode = null
var front = Vector3()
var rear = Vector3()
var newnode = preload("res://Objects/wirenode.tscn")

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
	front = $front.get_global_transform().origin
	rear = $rear.get_global_transform().origin
#code in the wires is only called from th nodes
#calling functions in nodes is not neccesairy appart from certain situations, such as when a new nodes is created or when a node is changed

#when replacing a node with another one
func connect_to_node(newnode, oldnode):
	if frontnode == oldnode:
		frontnode = newnode
		front = frontnode.get_global_transform().origin 
		frontnode.conn(self, rearnode)
	elif rearnode == oldnode:
		rearnode = newnode
		rear = rearnode.fet_global_transform().origin 
		rearnode.conn(self, frontnode)
#function for when the wire needs a new node
#also splits the wire the node gets put on
func newnode(pos, otherwire,frontback):
	#loads and adds new node to scene
	
	var newnode2 = newnode.instance()
	get_parent().add_child(newnode2)
	newnode2.global_transform.origin = pos
	var node
	if frontback == "front":
		node = rearnode
	else:
		node = frontnode
	var newpos = newnode2.conn(self, node)
	if frontback == "front":
		front = newpos
	else:
		rear = newpos
	otherwire.get_parent().split(newpos + Vector3(0, 0, 0.25), rear- Vector3(0, 0, 0.35), front+ Vector3(0, 0, 0.35), newpos - Vector3(0, 0, -0.25))
	

#splits a wire in 2
func split(beginpos, beginpos2, endpos, endpos2):
	var newwire = load("res://Objects/goodwire.tscn")
	var newwire2 = newwire.instance()
	newwire2.rear = beginpos
	newwire2.front = endpos
	front = endpos2
	rear = beginpos2
	resize()
	get_parent().add_child(newwire2)
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
