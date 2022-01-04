extends StaticBody

var type = "battery"


var temppaths = []

var posconnect = null
var negconnect = null
var posconnectwire = null
var negconnectwire = null

var posconnectbattery = false
var negconnectbattery = false

var flowing = false
var time = "perm"
var error = null

var all_paths = []
var paths = []
# paths = [ [id, resistance, [wires], [splits]], []]
var wires = []
var oldresistances = []
var splits = []
export(float) var volts = 1
export(float) var amps = 1

var closed = false
var closed_connecteds = []

#variables connmected to batteryconn & batterydisconn
var temp_path = []

var temp_node = []
var temp_nodes = []
#by which nodes is it connected to the positive end of the battery
var frombats = []

func _ready():
	Global_Variables.batteries.append(self)

func start_connecting(body = null):
	if posconnect != null && negconnect != null:
		ElectricsUpdate.update_all_electrical_components()
#gets called when a sygnal returns
func connecting(path, splits, resistance, body, oldresistance, batteries):
	if body == negconnect:
		if Global_Variables.batteries.size()== batteries.size():
			print("print5")
			if Global_Variables.paths.size() > 0:
				for j in Global_Variables.paths:
					var splitt = j['splits']
					var which = -1
					var which2 = -1
					if splits.size() > 0:
						var rev = splits
						rev.invert()
						for i in rev:
							var g = splitt.find(i)
							if g != -1:
								which = g
								var h = splits.find(i)
								if h != -1:
									which2 = h
								if oldresistance[which] == 0 && j["oldresistances"][which2] != 0:
									Global_Variables.paths.remove(Global_Variables.paths.find(j))
									Global_Variables.dead_paths.append(j)
								elif j["oldresistances"][which2] == 0 && oldresistance[which] != 0:
									return
			for i in path:
				if wires.has(i) == false:
					wires.append(i)
			all_paths.append({"path":path, "splits":splits, 'resistance':resistance,'oldresistances':oldresistance})
			var dict = {"path":path, "splits":splits, 'resistance':resistance,'oldresistances':oldresistance}
			print(dict)
			for i in Global_Variables.paths:
				if i["path"] != dict["path"]:
					Global_Variables.paths.append(dict)
			if resistance == 0:
				for h in Global_Variables.paths:
					if h['resistance'] != 0:
						Global_Variables.dead_routes.append(h)
						Global_Variables.paths.remove(Global_Variables.paths.find(h))
		else:
			var battnew = batteries
			battnew.append(self)
			var pathnew = path
			var splitsnew = splits
			posconnect.connecting(pathnew, splitsnew, resistance, self, oldresistance, battnew)
	else:
		body.notconnecting(self)

func posdiscon(body):
	if body.is_in_group('wire_end'):
		posconnectwire = null
		if flowing == true:
			flowing = false
		posconnectwire = null

func negcon(body):
	if body.is_in_group('wire_end'):
		print("hi")
		negconnectwire = body


func negdiscon(body):
	if body.is_in_group('wire_end'):
		negconnectwire = null
		if flowing == true:
			flowing = false
		negconnectwire = null


func poscon(body):
	if body.is_in_group('wire_end'):
		print("hi")
		posconnectwire = body


func _on_Timer_timeout():
	var rev = Global_Variables.paths
	print("print3")

func cunn(node, body2):
	if posconnect == body2:
		posconnect = node
	elif negconnect == body2:
		negconnect = node

func conecteds():
	if negconnect != null && posconnect != null:
		return [self, [posconnect, negconnect], type, 0]
	else:
		return [0, 0, "error"]

func get_info():
	if error == null:
		return(["battery", false, volts, amps, 0, error, flowing])
	else:
		return(["battery", true, volts, amps, 0, error, flowing])

func disconnect_node(node):
	if posconnect == node:
		posconnect.batterydisconn(self, [self], [self, "battery", 0, 0, 0, false])
		posconnect = null
		ElectricsUpdate.closed_batteries.erase(self)
		if ElectricsUpdate.closed_batteries.size() <1:
			ElectricsUpdate.battery_closed = false
		posconnectbattery = false
		if closed == true:
			node.con_close(false, self)
			negconnect.con_close(false, self)
		closed_connecteds.erase(node)
	elif negconnect == node:
		ElectricsUpdate.closed_batteries.erase(self)
		if ElectricsUpdate.closed_batteries.size() <1:
			ElectricsUpdate.battery_closed = false
		negconnect = null
		negconnectbattery = false
		if closed == true:
			node.con_close(false, self)
			posconnect.con_close(false, self)
		closed_connecteds.erase(node)

func disconnect_wire(node):
	if posconnectwire == node:
		posconnectwire = null
		if posconnect !=  null:
			posconnect.batterydisconn(self)
			posconnect = null
			posconnectbattery = false
	elif negconnectwire == node:
		negconnectwire = null
		if negconnect !=  null:
			negconnect = null
			negconnectbattery = false

func conn(wire, node, dir= null, onof = false, ampvolt = []):
	var dirr = dir
	if dir == null:
		if wire == posconnectwire:
			dirr = "front"
		if wire == negconnectwire:
			dirr= "rear"
	if dirr == 'front':
		posconnectwire = wire
		if node != null:
			posconnect = node
			posconnect.batteryconn(self, [self],[self, "battery", 0, 0, 0, false], volts, amps)
			if negconnect != null:
				ElectricsUpdate.battery_closed = true
				ElectricsUpdate.closed_batteries.append(self)
		return [$pos.global_transform.origin, 0, amps, volts]
	elif dirr == 'rear':
		negconnectwire = wire
		if node != null:
			negconnect = node
			if posconnect != null:
				ElectricsUpdate.battery_closed = true
				ElectricsUpdate.closed_batteries.append(self)
		return [$neg.global_transform.origin, 1]

func con_node(node, wire, is_battery = null):
	if wire == posconnectwire:
		posconnect = node
		posconnect.batteryconn(self,[self],[[self, "battery", 0, 0, 0, false]], volts, amps)
		#(originnode,nodes, [[node, nodetype, volt, amp, resistance, ], other pathbits]voltflow, ampflow)
		if is_battery == true:
			posconnectbattery = true
		if negconnect != null:
			
			ElectricsUpdate.battery_closed = true
			ElectricsUpdate.closed_batteries.append(self)
	elif wire == negconnectwire:
		negconnect = node
		if is_battery == true:
			negconnectbattery = true
		if posconnect != null:
			ElectricsUpdate.battery_closed = true
			ElectricsUpdate.closed_batteries.append(self)

func con_close(truefalse, node):
	if truefalse == true:
		closed_connecteds.append(node)
	else:
		closed_connecteds.erase(node)


func voltsamps(amp, volt, wire, replace = true, clear = false): 
	if replace == true:
		volts = volt
		amps = amp
	elif replace == false:
		volts = (((volts * amps) + (volt * amp))/(amps+amp))
		amps += amp
	if clear == false:
		if wire != null:
			var volt_removal
			for i in wires:
				if i != wire:
					i.voltsamps(amps, volts - volt_removal, self)


func batteryconn(node,nodes, path, amp, volt):
	print("jhi")
	if temppaths.size() != 0:
		$Timer3.start(0.1666)
	temppaths.append(path)

func batterydisconn(node,nodes, path):
	pass

func _on_Timer3_timeout():
	#find paths do smthing i guess
	pass

func changed():
	start_connecting()
