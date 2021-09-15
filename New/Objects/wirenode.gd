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
#adds wire to the wirestack
func conn(wire):
	wires.append(wire)

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

func connect_wire(body):
	if body.is_in_group("wires"):
		pass
	elif body.is_in_group("wire_nodes"):
		pass

func disconnect_wire(body):
	if body.is_in_group("wires"):
		pass
	elif body.is_in_group("wire_nodes"):
		pass
