extends Spatial

var positiveconnect
var negativeconnect
export(String, "node", "appliance", "non_appliance") var type = "node"
export(float) var resistance
export(float, 0.1, 100, 0.1) var volt_needs
export(float, 0.01, 100, 0.1) var watt_needs

var wire_path = null
var error = null
var flowing = false

var electricity_flowing = false
var connected = false

var poscon = null
var negcon = null
var posconwire = null
var negconwire = null

var posconbattery = false
var negconbattery = false
var time = "perm"

var closed = false
var closed_connecteds = []
var connected_to_battery = "not"

var amps = 0
var volts = 0

func _ready():
	pass 

func connecting(path, resistance, body, oldresistances):
	pass

func power(paths, splits, volt, amp):
	pass

func conecteds():
	if positiveconnect != null && negativeconnect != null:
		return [self, [positiveconnect, negativeconnect], type, resistance]
	else:
		return "error"

func get_info():
	return(["appliance", volts, amps, resistance, error, flowing, volt_needs, watt_needs])


func _on_rear_body_entered(body):
	if negconwire == null:
		negconwire = body


func _on_rear_body_exited(body):
	if body == negconwire:
		negconwire = null
 

func _on_front_body_entered(body):
	if posconwire == null:
		posconwire = body


func _on_front_body_exited(body):
	if body == posconwire:
		posconwire = null

func conn(wire, newnode, frontback, auto = false, voltamp = []):
	var posss
	print("hi")
	#get closest
	var posarr = []
	var pos
	var stop = false
	if frontback == "front":
		posconwire = wire
		return [$pos1.get_global_transform().origin, 0]
	elif frontback == "rear":
		negconwire = wire
		return [$pos2.get_global_transform().origin, 1]
	if newnode != null:
		if !poscon == newnode && frontback == "front":
			poscon = newnode
			if negcon != null:
				closed = true
				negcon.con_close(true, self)
				poscon.con_close(true, self)
				if closed_connecteds.size() > 1:
					if ElectricsUpdate.battery_closed == true:
						ElectricsUpdate.closed_batteries(0).start_connecting()
		if !negcon == newnode && frontback == "rear":
			negcon = newnode
			if poscon != null:
				closed = true
				negcon.con_close(true, self)
				poscon.con_close(true, self)
				if closed_connecteds.size() > 1:
					if ElectricsUpdate.battery_closed == true:
						ElectricsUpdate.closed_batteries(0).start_connecting()

func disconnect_wire(wire):
	if wire == posconwire:
		posconwire = null
		if poscon != null:
			poscon = null
			posconbattery = false
	elif wire == negconwire:
		negconwire = null
		if negcon != null:
			negcon = null
			negconbattery = false

func disconnect_node(node):
	if node == poscon:
		closed = false
		if negcon != null:
			negcon.con_close(false, self)
		if poscon != null:
			poscon.con_close(false, self)
		posconbattery = false
		poscon = null
	elif node == negcon:
		closed = false
		if negcon != null:
			negcon.con_close(false, self)
		if poscon != null:
			poscon.con_close(false, self)
		negcon = null
		negconbattery = false

func con_node(node, wire, is_battery = null):
	if wire == posconwire:
		poscon = node
		if is_battery == true:
			posconbattery = true
		if negcon != null:
			closed = true
			negcon.con_close(true, self)
			poscon.con_close(true, self)
			if closed_connecteds.size() > 1:
				if ElectricsUpdate.battery_closed == true:
					ElectricsUpdate.closed_batteries(0).start_connecting()
	elif wire == negconwire:
		negcon = node
		if is_battery == true:
			negconbattery = true
		if poscon != null:
			closed = true
			negcon.con_close(true, self)
			poscon.con_close(true, self)
			if closed_connecteds.size() > 1:
				if ElectricsUpdate.battery_closed == true:
					ElectricsUpdate.closed_batteries(0).start_connecting()

func con_close(truefalse, node):
	if truefalse == true:
		closed_connecteds.append(node)
	else:
		closed_connecteds.erase(node)

