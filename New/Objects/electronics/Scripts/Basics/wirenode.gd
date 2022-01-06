 extends KinematicBody

class MyCustomSorter:
	static func sort_ascending(a, b):
		if a[0] < b[0]:
			return true
		return false

#if the node is connected to the battery in some way
var negbattery
var negbattery_paths
var negconns = []
var posbattery
var posbattery_paths
var posconns = []

const MAX_COMPONENT_UPDATES_PER_FRAME = 10

var electrical_update_in_progress = false

var time = "perm"
export(bool) var onstart = false
export(String, "node", "appliance", "non_appliance") var type = "node"

var connected_to_battery = "not"
var closed = false
var closed_connecteds = []

var printtt = 0
var connecteds = []
var wires = []

var gravity = Vector3.DOWN * 18
var velocety = Vector3()
var damp = Vector3(1, 0, 1)
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

var pos_wire1 = null
var pos_wire2 = null
var pos_wire3 = null
var pos_wire4 = null

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

var held = false

#variables connmected to batteryconn & batterydisconn
var temp_path = []

var temp_node = []
var temp_nodes = []
#by which nodes is it connected to the positive end of the battery
var frombats = []
var con_to_batt = false

func _ready():
	oldpos = translation
	if onstart == true:
		$plug.get_surface_material(0).albedo_color.a = 1

#adds wire to the wirestack and adds the other node connected to thats wire to self
func conn(wire, newnode, frontback, auto = false, volamp = []):
	var posss
	if volamp.size()>0:
		if con_to_batt == false:
			volts = volamp[1]
			amps = volamp[0]
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
	if newnode != null:
		if !connecteds.has(newnode):
			connecteds.append(newnode)
			if con_to_batt == true:
				for i in temp_nodes:
					if !i.has(newnode):
						newnode.batteryconn(self,i, temp_path[temp_nodes.find(i)], volts, amps)
			if connecteds.size() > 1 && closed == false:
				closed = true
				for i  in connecteds:
					i.con_close(true, self)
	if stop == false:
		posarr.sort_custom(MyCustomSorter, "sort_ascending")
		pos = posarr[0][2]
		set("pos" + String(posarr[0][1]), wire)
		return [pos, posarr[0][1]]

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
		if connecteds.size() > 1 && closed == false:
			closed = true
			for i  in connecteds:
				i.con_close(true, self)
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
		if closed == true:
			node.con_close(false, self)
			if connecteds.size() < 2:
				closed = true
				for i  in connecteds:
					i.con_close(false, self)
		#battery.start_connecting()


func wire(wire, node):
	if !wires.has(wire):
		wires.append(wire)
	if !connecteds.has(node):
		connecteds.append(node)
		
#when the player pickes the node up

func pickup():
	held = true
func drop(vel, hi2):
	velocety = vel
	held =false
	
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
	if wires.size() < 1:
		if held == false:
			velocety += gravity * delta
			if is_on_floor() || is_on_ceiling():
				velocety -= 10*(velocety*(damp*Vector3(delta, delta, delta)))
			elif is_on_wall():
				velocety -= 5*(velocety*(damp*Vector3(delta, delta, delta)))
			else: 
				velocety -= (velocety*(damp*Vector3(delta, delta, delta)))
			velocety = move_and_slide(velocety, Vector3.UP)

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

func con_close(truefalse, node):
	if truefalse == true:
		closed_connecteds.append(node)
	else:
		closed_connecteds.erase(node)

func negbattery(onof,node, wire, path = []):
	negbattery = onof
	if onof == false:
		if negbattery_paths.has(path):
			negbattery_paths.erase(path)
	elif !negbattery.has(path):
		negbattery.append(path)

func posbattery(onof, node, wire, paths = [[]]):
	posbattery = onof
	var paf = paths
	if onof == false:
		if posbattery_paths.has(paths):
			posbattery_paths.erase(paths)
		if posconns.has(node):
			posconns.erase(node)
			if posconns.size() == 0:
				for i in connecteds:
					if i != node:
						var poss
						if i == pos_node1:
							pos1.posbattery(false, self, paf)
							poss = pos1
						elif i == pos_node2:
							pos2.posbattery(false, self, paf)
							poss = pos2
						elif i == pos_node3:
							pos3.posbattery(false, self, paf)
							poss = pos3
						elif i == pos_node4:
							pos4.posbattery(false, self, paf)
							poss = pos4
						i.posbattery(false, self, poss)
	if !paf.has(self):
		paf.append(node)
		if onof == true:
			if !posconns.has(node):
				if posconns.size() == 0:
					for i in connecteds:
						if i != node:
							var poss
							if i == pos_node1:
								pos1.posbattery(true, self, paf)
								poss = pos1
							elif i == pos_node2:
								pos2.posbattery(true, self, paf)
								poss = pos2
							elif i == pos_node3:
								pos3.posbattery(true, self, paf)
								poss = pos3
							elif i == pos_node4:
								pos4.posbattery(true, self, paf)
								poss = pos4
							i.posbattery(false, self, poss)
				posconns.append(node)
			if !posbattery.has(paths):
				posbattery.append(paths)

func voltsamps(amp, volt, wire, replace = true, clear = false):
	if replace == true:
		volts = volt
		amps = amp
	else:
		volts = ((volt*amp)+(volts*amps)) / (amps + amp)
		amps+= amp
	if clear  == false:
		if wire != null:
			var amp_multiplier = 1
			if wires.size() > 1:
				amp_multiplier = 1 / (wires.size() - 1)
			for i in wires:
				if i != wire:
					i.voltsamps(amps* amp_multiplier, volts, self)

func batteryconn(node, nodes, path, amp, volt):
	amps = amp
	volts = volt
	var nodess = nodes
	var paths = path
	if !nodess.has(self):
		nodess.append(self)
		paths.append([self, "node", 0, 0, 0, false])
		if !temp_path.has(paths):
			temp_path.append(paths)
		if !temp_nodes.has(nodess):
			temp_nodes.append(nodess)
		if connecteds.has(node):
			print('hi')
			temp_node.append(node)
			if !frombats.has(node):
				frombats.append(node)
			if con_to_batt != true:
				print("hi3")
				con_to_batt = true
		for i in connecteds:
			if i != node && !nodess.has(i):
				print("hi2")
				i.batteryconn(self, nodess, paths, amp, volt)
		

func batterydisconn(node, nodes, path):
	var paths = path
	var nodess = nodes
	nodess.append(self)
	paths.append([self, "node", 0, 0, 0, false])
	if temp_path.has(path):
		temp_path.erase(path)
		volts = 0
		amps = 0
		temp_nodes.erase(nodess)
		if temp_node.has(node):
			temp_node.erase(node)
			for i in connecteds:
				if i != node:
					i.batterydisconn(self,nodess, paths)
			if !temp_node.has(node):
				if frombats.has(node):
					frombats.erase(node)
					if frombats.size() == 0:
						con_to_batt = false

func delete():
	print('i')
	for i in wires:
		i.discon_node(self)
	wires = []
	connecteds = []
	queue_free()
