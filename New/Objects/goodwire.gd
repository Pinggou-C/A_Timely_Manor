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
