 extends KinematicBody

class MyCustomSorter:
	static func sort_ascending(a, b):
		if a[0] < b[0]:
			return true
		return false


var printtt = 0
var connecteds = []
var wires = []

var flowing = false
var connected = false

var pickedup = false
var selfwire = null

var oldpos

#all the sides and their positions
var pos1 = null
var pos2 = null
var pos3 = null
var pos4 = null



var powered_by = []
var volts
var amps
var path0 =[]
var resistance0 =0
var oldresistance0 =[]
var splits0 =[]

func _ready():
	oldpos = translation

#adds wire to the wirestack and adds the other node connected to thats wire to self
func conn(wire, newnode, frontback):
	var posss
	#get closest
	var posarr = []
	if frontback == "front":
		posss = wire.rear
	else:
		posss = wire.front
	if !wires.has(wire):
		wires.append(wire)
		var pos
		if pos1 == null:
			print($pos1.get_global_transform().origin)
			print(posss)
			var g = posss- $pos1.get_global_transform().origin
			posarr.append([abs((posss.x - $pos1.get_global_transform().origin.x) + (posss.y - $pos1.get_global_transform().origin.y) + (posss.z - $pos1.get_global_transform().origin.z)), 1, $pos1.get_global_transform().origin])
		elif pos2 == null:
			posarr.append([abs((posss.x - $pos2.get_global_transform().origin.x) + (posss.y - $pos2.get_global_transform().origin.y) + (posss.z - $pos2.get_global_transform().origin.z)), 2, $pos2.get_global_transform().origin])
		elif pos3 == null:
			posarr.append([abs((posss.x - $pos3.get_global_transform().origin.x) + (posss.y - $pos3.get_global_transform().origin.y) + (posss.z - $pos3.get_global_transform().origin.z)), 3, $pos3.get_global_transform().origin])
		elif pos4 == null:
			posarr.append([abs((posss.x - $pos4.get_global_transform().origin.x) + (posss.y - $pos4.get_global_transform().origin.y) + (posss.z - $pos4.get_global_transform().origin.z)), 4, $pos4.get_global_transform().origin])
		posarr.sort_custom(MyCustomSorter, "sort_ascending")
		pos = posarr[0][2]
		set("pos" + String(posarr[0][1]), wire)
		return pos
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
func drop(hi1, hi2):
	pass

func enter(which):
	#when i wire gets connected
	pass


func _physics_process(delta):
	if abs(oldpos.x - translation.x) > 0.01 || abs(oldpos.y - translation.y) > 0.01 || abs(oldpos.z - translation.z) > 0.01:
		for i in connecteds:
			i.resize()
	oldpos = translation
