 extends KinematicBody

var printtt = 0
var connecteds = []
var wires = []

var flowing = false
var connected = false

var pickedup = false
var selfwire = null

var powered_by = []
var volts
var amps
var path0 =[]
var resistance0 =0
var oldresistance0 =[]
var splits0 =[]
#adds wire to the wirestack and adds the other node connected to thats wire to self
func conn(wire, newnode):
	if !wires.has(wire):
		wires.append(wire)
	if !connecteds.has(newnode):
		connecteds.append(newnode)

func onwire(wire, position, contype):
	pass

func onnode(node, position, contype):
	if contype == "connect":
		var pos = node.get_global_translation()
		translation = pos
		#calls its own wire to replace itself with a new node
		selfwire.connect_to_node(node, self)
		#removes itself when not needed
		self.queue_free()
	elif contype == "disconnect":
		#if it is disconnecting
		pass
#pathfind function
func connecting(path, resistance, body, oldresistances):
	if !path.has(self):
		powered_by.append(body)
		var pathnew = path
		var oldresistancenew = oldresistances
		pathnew.append(self)
		oldresistancenew.append(0)
		for i in connecteds:
			if i != body:
				i.connecting(pathnew, resistance, self, oldresistancenew)

func power(paths, splits, volt, amp):
	if volts == 0:
		volts = volt
	else:
		#calculates voltage if it has already been powered once
		pass
	if amps ==0:
		amps = amp
	else:
		#calculates amps is already been powered
		pass

#when a wire or node enters th area
func connect_wire(body):
	if body.is_in_group("wires"):
		var nodeassign = body.front_node
		var nodebottom = body.rear_node
		var nodepos = body.front
		body.resize_node(self, translation)
		#creates the new wire and connects it to the node
		var newwire = load("res://Objects/goodwire.tscn")
		newwire.instance()
		get_parent().add_child(newwire)
		wires.append(newwire)
		#connects nodes to the new wire
		newwire.connect_node_front(nodeassign, nodepos)
		newwire.connect_node_rear(self, translation)
		#connects new nodes to self if it doesnt yet have them
		if !connecteds.has(nodeassign):
			connecteds.assign(nodeassign)
		if !connecteds.has(nodebottom):
			connecteds.assign(nodebottom)
		if !wires.has(newwire):
			wires.append(newwire)
	elif body.is_in_group("wire_nodes"):
		for i in wires:
			i.connect_to_node(body, self)

#when the wire get picked up and disconnected
func disconnect_wire(wires, ownwire):
	if wires.size() > 2:
		for i in wires:
			pass
	elif wires.size() == 2:
		if wires[0].frontnode == self:
			wires[0].combine(wires[1])
		else:
			wires[1].combine(wires[0])
	elif wires.size() == 1:
		pass


func wire(wire, node):
	if !wires.has(wire):
		wires.append(wire)
	if !connecteds.has(node):
		connecteds.append(node)
		
#when the player pickes the node up

func pickup():
	pass
func drop():
	pass
