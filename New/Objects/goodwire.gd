extends Spatial

var frontnode = null
var rearnode = null
#when replacing a node with another one
func connect_to_node(newnode, oldnode):
	if frontnode == oldnode:
		frontnode = newnode
		rearnode.conn(self)
	elif rearnode == oldnode:
		rearnode = newnode
		rearnode.conn(self)
#function for when the wire needs a new node
func newnode(position, oldnode, pos):
	#loads and adds new node to scene
	var newnode = load("res://Objects/wirenode.tscn")
	newnode.instance()
	get_parent().add_child(newnode)
	newnode.translation = pos
	newnode.conn(self)
