extends Spatial

var frontnode = null
var rearnode = null
var front = Vector3()
var rear = Vector3()

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
	add_child(mycoll1)
	var mycol = CollisionShape.new()
	mycol.shape = BoxShape.new()
	mycol.shape.extents = Vector3(0.01, 0.01, 0.01)
	mycoll1.add_child(mycol)
	mycoll1.set_collision_layer_bit(0, false)
	mycoll1.set_collision_layer_bit(1, true)
	mycoll1.set_collision_layer_bit(3, true)
	var mycoll2 = StaticBody.new()
	add_child(mycoll2)
	var mycol1 = CollisionShape.new()
	mycol1.shape = BoxShape.new()
	mycol1.shape.extents = Vector3(0.01, 0.01, 0.01)
	mycoll2.add_child(mycol1)
	mycoll2.set_collision_layer_bit(0, false)
	mycoll2.set_collision_layer_bit(1, true)
	mycoll2.set_collision_layer_bit(3, true)
	var mycoll3 = StaticBody.new()
	add_child(mycoll3)
	var mycol2 = CollisionShape.new()
	mycol2.shape = BoxShape.new()
	mycol2.shape.extents = Vector3(0.01, 0.01, 0.01)
	mycoll3.add_child(mycol2)
	mycoll3.set_collision_layer_bit(0, false)
	mycoll3.set_collision_layer_bit(1, true)
	mycoll3.set_collision_layer_bit(3, true)
#code in the wires is only called from th nodes
#calling functions in nodes is not neccesairy appart from certain situations, such as when a new nodes is created or when a node is changed

#when replacing a node with another one
func connect_to_node(newnode, oldnode):
	if frontnode == oldnode:
		frontnode = newnode
		front = frontnode.get_global_position()
		frontnode.conn(self, rearnode)
	elif rearnode == oldnode:
		rearnode = newnode
		rear = rearnode.get_global_position()
		rearnode.conn(self, frontnode)
#function for when the wire needs a new node
func newnode(position, oldnode, pos):
	#loads and adds new node to scene
	var newnode = load("res://Objects/wirenode.tscn")
	newnode.instance()
	get_parent().add_child(newnode)
	newnode.translation = pos
	newnode.conn(self)

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
			rear = otherwire.front
			rearnode = otherwire.frontnode
		elif which == "front":
			rear = otherwire.rear
			rearnode = otherwire.rearnode
	if which2 == "front":
		if which == "back":
			front = otherwire.front
			frontnode = otherwire.frontnode
		elif which == "front":
			front = otherwire.rear
			frontnode = otherwire.rearnode
	otherwire.frontnode.wire(self, rearnode)
	otherwire.queue_free()
	resize()

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
		wire1.translation = Vector3(-(rear.x - front.x)/ 2+rear.x, rear.y, rear.z)
		wirecoll1.translation = wire1.translation
		wire2.mesh.size = z1
		wirecoll2.shape.extents = z1 / 2
		wire2.translation = Vector3(-(rear.x - front.x)+rear.x, rear.y, -(rear.z - front.z) / 2 + rear.z)
		wirecoll2.translation = wire2.translation
		wire3.mesh.size = y1
		wirecoll3.shape.extents = y1 / 2
		wire3.translation = Vector3(-(rear.x - front.x)+rear.x, -(rear.y - front.y) / 2 + rear.y, -(rear.z - front.z) + rear.z)
		wirecoll3.translation = wire3.translation
	elif z > x && z > y:
		wire1.mesh.size = z1
		wirecoll2.shape.extents = z1 / 2
		wire1.translation =Vector3(rear.x, rear.y, -(rear.z - front.z)/ 2 + rear.z)
		wirecoll2.translation = wire1.translation
		wire2.mesh.size = x1
		wirecoll1.shape.extents = x1 /2
		wire2.translation = Vector3(-(rear.x - front.x) / 2 + rear.x, rear.y, -(rear.z - front.z)+rear.z)
		wirecoll1.translation = wire2.translation
		wire3.mesh.size = y1
		wirecoll3.shape.extents = y1 / 2
		wire3.translation = Vector3(-(rear.x - front.x)+rear.x, -(rear.y - front.y) / 2 + rear.y, -(rear.z - front.z) + rear.z)
		wirecoll3.translation = wire3.translation
	else:
		wire1.mesh.size = y1
		wirecoll3.shape.extents = y1 / 2
		wire1.translation =Vector3(rear.x, -(rear.y - front.y)/ 2 + rear.y, rear.z)
		wirecoll3.translation = wire1.translation
		wire2.mesh.size = x1
		wirecoll1.shape.extents = x1 /2
		wire2.translation = Vector3(-(rear.x - front.x) / 2 + rear.x, -(rear.y - front.y) + rear.y, rear.z)
		wirecoll1.translation = wire2.translation
		wire3.mesh.size = z1
		wirecoll2.shape.extents = z1 / 2
		wire3.translation = Vector3(-(rear.x - front.x)+rear.x, -(rear.y - front.y) + rear.y, -(rear.z - front.z) / 2 + rear.z)
		wirecoll2.translation = wire3.translation
	$rear.translation = rear
	$front.translation = front
	$reararea.translation = rear
	$frontarea.translation = front
