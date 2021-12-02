extends StaticBody

var positiveconnect
var negativeconnect
export(String, "node", "appliance", "non_appliance") var type = "node"
export(float) var resistance
export(float, 0.1, 100, 0.1) var volts
export(float, 0.01, 100, 0.1) var watts


var wire_amps = 0
var wire_volts = 0
var wire_path = null
var error = null
var flowing = false

var electricity_flowing = false
var connected = false

var pos_connect = null
var neg_connect = null

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
	return(["appliance", wire_volts, wire_amps, resistance, error, flowing, volts, watts])


func _on_rear_body_entered(body):
	if neg_connect == null:
		neg_connect = body


func _on_rear_body_exited(body):
	if body == neg_connect:
		neg_connect = null
 

func _on_front_body_entered(body):
	if pos_connect == null:
		pos_connect = body


func _on_front_body_exited(body):
	if body == pos_connect:
		pos_connect = null
