 extends KinematicBody

class MyCustomSorter:
	static func sort_ascending(a, b):
		if a[0] < b[0]:
			return true
		return false

const MAX_COMPONENT_UPDATES_PER_FRAME = 10

var electrical_update_in_progress = false

var time = "perm"

export(String, "node", "appliance", "non_appliance") var type = "node"

var printtt = 0
var connecteds = []
var wires = []

var battery

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

var pos_node1 = null
var pos_node2 = null
var pos_node3 = null
var pos_node4 = null

var pos1_battery = false
var pos2_battery = false
var pos3_battery = false
var pos4_battery = false

var powered_by = []

var volts = 0
var amps = 0
var error = null

var path0 =[]
var resistance0 =0
var oldresistance0 =[]
var splits0 =[]

func _ready():
	oldpos = translation

#adds wire to the wirestack and adds the other node connected to thats wire to self
func conn(wire, newnode, frontback, auto = false):
	var posss
	#get closest
	var posarr = []
	if auto != true:
		if frontback == "front":
			posss = wire.rear
		elif frontback == "rear":
			posss = wire.front
	else:
		if frontback == "front":
			posss = wire.front
		elif frontback == "rear":
			posss = wire.rear
	if !wires.has(wire):
		wires.append(wire)
	var pos
	var stop = false
	if pos1 == null:
		posarr.append([sqrt(pow(posss.x - $pos1.get_global_transform().origin.x, 2) + pow(posss.z - $pos1.get_global_transform().origin.z, 2) + pow(posss.y - $pos1.get_global_transform().origin.y, 2)), 1, $pos1.get_global_transform().origin])
	if pos2 == null:
		posarr.append([sqrt(pow(posss.x - $pos2.get_global_transform().origin.x, 2) + pow(posss.z - $pos2.get_global_transform().origin.z, 2) + pow(posss.y - $pos2.get_global_transform().origin.y, 2)), 2, $pos2.get_global_transform().origin])
	if pos3 == null:
		posarr.append([sqrt(pow(posss.x - $pos3.get_global_transform().origin.x, 2) + pow(posss.z - $pos3.get_global_transform().origin.z, 2) + pow(posss.y - $pos3.get_global_transform().origin.y, 2)), 3, $pos3.get_global_transform().origin])
	if pos4 == null:
		posarr.append([sqrt(pow(posss.x - $pos4.get_global_transform().origin.x, 2) + pow(posss.z - $pos4.get_global_transform().origin.z, 2) + pow(posss.y - $pos4.get_global_transform().origin.y, 2)), 4, $pos4.get_global_transform().origin])
	if pos4 != null && pos3 != null && pos2 != null && pos1 != null :
		stop = true
	if stop == false:
		posarr.sort_custom(MyCustomSorter, "sort_ascending")
		pos = posarr[0][2]
		set("pos" + String(posarr[0][1]), wire)
		return [pos, posarr[0][1]]
	if newnode != null:
		if !connecteds.has(newnode):
			connecteds.append(newnode)

func onnode(node, position, contype):
	if contype == "connect":
		var pos = node.get_global_transform().origin
		translation = pos
		#calls its own wire to replace itself with a new node
		selfwire.connect_to_node(node, self)
		#removes itself when not needed
		self.queue_free()
	elif contype == "disconnect":
		#if it is disconnecting
		pass

func con_node(node, wire, is_battery = null):
	if !connecteds.has(node):
		connecteds.append(node)
	if wire == pos1:
		pos_node1 = node
		if is_battery == true:
			pos1_battery = true
	elif wire == pos2:
		pos_node2 = node
		if is_battery == true:
			pos2_battery = true
	elif wire == pos3:
		pos_node3 = node
		if is_battery == true:
			pos3_battery = true
	elif wire == pos4:
		pos_node4 = node
		if is_battery == true:
			pos4_battery = true
#
#
#
#
#
#
#pathfind function
func connecting(path, splits, resistance, body, oldresistances, batteries):
	print("print4")
	if !path.has(self):
		print("print2")
		if ElectricsUpdate.updated_components == ElectricsUpdate.MAX_COMPONENT_UPDATES_PER_FRAME:
		# Yield until the next physics frame, allowing other parts of your code to execute.	
			print('stop')
			yield(get_tree(), "physics_frame") 
			ElectricsUpdate.updated_components = 0
		powered_by.append(body)
		var pathnew = path
		var splitsnew = splits
		if connecteds.size() > 2:
			splitsnew.append(self)
		var oldresistancenew = oldresistances
		pathnew.append(self)
		oldresistancenew.append(0)
		ElectricsUpdate.updated_components += 1
		print(connecteds.size())
		print(wires.size())
		print(pathnew)
		for i in connecteds:
			print(i)
			if i != body:
				i.connecting(pathnew, splitsnew,resistance, self, oldresistancenew, batteries)
		

func power(paths, splits, volt, amp):
	if ElectricsUpdate.updated_components == ElectricsUpdate.MAX_COMPONENT_UPDATES_PER_FRAME:
		# Yield until the next physics frame, allowing other parts of your code to execute.	
		yield(get_tree(), "physics_frame") 
		ElectricsUpdate.updated_components = 0
	ElectricsUpdate.updated_components += 1
	for path in paths:
		path.remove(0)
		for i in connecteds:
			if path.has(i):
				pass
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
	return
	var hello = false
	if body.is_in_group("wires") && hello == true:
		var nodeassign = body.front_node
		var nodebottom = body.rear_node
		var nodepos = body.front
		body.resize_node(self, translation)
		#creates the new wire and connects it to the node
		var newwire = load("res://Objects/electronics/Items/Basics/goodwire.tscn")
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
func disconnect_wire(wire, special = false):
	if wires.has(wire):
		wires.remove(wires.find(wire))
	if pos1 == wire:
		pos1 = null
		pos1_battery = false
		pos_node1 = null
	elif pos2 == wire:
		pos2 =  null
		pos2_battery = false
		pos_node2 = null
	elif pos3 == wire:
		pos3 = null
		pos3_battery = false
		pos_node3 = null
	elif pos4 == wire:
		pos4 = null
		pos4_battery = false
		pos_node4 = null
	if special == true:
		print('2')
		if wires.size() > 2:
			for i in wires:
				pass
		elif wires.size() == 2:
			$Tween.interpolate_property($plug.get_surface_material(0), "albedo_color", Color(0.8, 0.8, 0.8, 1), Color(0.8, 0.8, 0.8, 0), 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			$Tween.start()
			var which2 = "front"
			if self == wires[0].frontnode:
				which2 = "back"
			var which1 = "front"
			if self == wires[1].frontnode:
				which1 = "rear"
			wires[0].combine(wires[1], which2, which1)
			queue_free()
			#wires[1].combine(wires[0])


func disconnect_node(node):
	if connecteds.has(node):
		connecteds.remove(connecteds.find(node))
		#battery.start_connecting()


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
	if get_global_transform().origin != oldpos:
		for i in wires:
			print(i)
			var pos
			if i == pos1:
				pos = $pos1.get_global_transform().origin
			elif i == pos2:
				pos = $pos2.get_global_transform().origin
			elif i == pos3:
				pos = $pos3.get_global_transform().origin
			elif i == pos4:
				pos = $pos4.get_global_transform().origin
			i.change_size(self, pos)
		oldpos = get_global_transform().origin

func perm():
	time = "perm"
	$Tween.interpolate_property($plug.get_surface_material(0), "albedo_color", Color(0.8, 0.8, 0.8, 0.7), Color(0.8, 0.8, 0.8, 1), 0.2, Tween.TRANS_LINEAR)
	$Tween.start()

func temp():
	time = "temp"
	$Tween.interpolate_property($plug.get_surface_material(0), "albedo_color", Color(0.8, 0.8, 0.8, 0.0), Color(0.8, 0.8, 0.8, 0.7), 0.25, Tween.TRANS_LINEAR)
	$Tween.start()

#calls the wire which couldnt connect because it corrected to the wrong end of an object
func notconnecting(battery):
	if battery == pos_node1:
		pos1.not_connecting(battery)
	elif battery == pos_node2:
		pos2.not_connecting(battery)
	elif battery == pos_node3:
		pos3.not_connecting(battery)
	elif battery == pos_node4:
		pos4.not_connecting(battery)

func disconnect_all():
	for i in wires:
		i.discon_node(self)

		
func conecteds():
	if connecteds.size() > 1:
		return [self, connecteds, type, 0]
	else:
		return [0, 0, "error"]

func get_info():
	if error != null:
		return(["node", true, volts, amps, 0, error, flowing])
	else:
		return(["node", false, volts, amps, 0, error, flowing])
