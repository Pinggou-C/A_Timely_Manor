extends Spatial

var frontnode = null
var rearnode = null
var front = Vector3()
var rear = Vector3()

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

func combine(otherwire):
	var frontpos = otherwire.front
	var nodefront = otherwire.frontnode
	otherwire.frontnode.wire(self, rearnode)
	otherwire.queue_free()

#generates wire
func resize():
	var x = abs(rear.x - front.x)
	var z = abs(rear.z - front.z)
	var y = abs(rear.y - front.y)
	get_child(3).queue_free()
	get_child(2).queue_free()
	get_child(4).queue_free()
	var wire1 = MeshInstance.new()
	wire1.mesh = CubeMesh.new()
	var wire2 = MeshInstance.new()
	wire2.mesh = CubeMesh.new()
	var wire3 = MeshInstance.new()
	wire3.mesh = CubeMesh.new()
	if x > z && x > y:
		wire1.mesh.size = Vector3(x, 0.05, 0.05)
		wire1.translation = Vector3(-(rear.x - front.x)/ 2+rear.x, rear.y, rear.z)
		wire2.mesh.size = Vector3(0.05, 0.05, z)
		wire2.translation = Vector3(-(rear.x - front.x)+rear.x, rear.y, -(rear.z - front.z) / 2 + rear.z)
		wire3.mesh.size = Vector3(0.05, y, 0.05)
		wire3.translation = Vector3(-(rear.x - front.x)+rear.x, -(rear.y - front.y) / 2 + rear.z, -(rear.z - front.z) + rear.z)
	elif z > x && z > y:
		wire1.mesh.size = Vector3(0.05, 0.05, z)
		wire1.translation =Vector3(rear.x, rear.y, -(rear.z - front.z)/ 2 + rear.z)
		wire2.mesh.size = Vector3(x, 0.05, 0.05)
		wire2.translation = Vector3(-(rear.x - front.x) / 2 + rear.x, rear.y, -(rear.z - front.z)+rear.z)
		wire3.mesh.size = Vector3(0.05, y, 0.05)
		wire3.translation = Vector3(-(rear.x - front.x)+rear.x, -(rear.y - front.y) / 2 + rear.y, -(rear.z - front.z) + rear.z)
	else:
		wire1.mesh.size = Vector3(0.05, y, 0.05)
		wire1.translation =Vector3(rear.x, -(rear.y - front.y)/ 2 + rear.y, rear.z)
		wire2.mesh.size = Vector3(x, 0.05, 0.05)
		wire2.translation = Vector3(-(rear.x - front.x) / 2 + rear.x, -(rear.y - front.y) + rear.y, rear.z)
		wire3.mesh.size = Vector3(0.05, 0.05, z)
		wire3.translation = Vector3(-(rear.x - front.x)+rear.x, -(rear.y - front.y) + rear.y, -(rear.z - front.z) / 2 + rear.z)
	add_child(wire1)
	add_child(wire2)
	add_child(wire3)
	$rear.translation = rear
	$front.translation = front
