extends RigidBody

var conns = []
var poscon = false
var negcon = false
var flowing = false
var connected = false

func _ready():
	pass # Replace with function body.

func connecting(path, resistance, split, body):
	if connected == true:
		return
	var paths = path.append(self)
	var splits = split
	if conns > 2:
		splits.append(self)
	if conns.size > 1:
		for i in conns:
			if i != body:
				i.connecting(paths, resistance, splits, self)
		connected = true
	else:
		Global_Variables.dead_routes.append(paths)
		return

func middle_connect(body):
	conns.append(body)
	if conns>1:
		Global_Variables.batteries[0].start_connecting()

func middle_disconnect(body):
	if conns.has(body):
		conns.remove(conns.find(body))


func positive_connect(body):
	poscon = body
	conns.append(body)
	if conns>1:
		Global_Variables.batteries[0].start_connecting()


func positive_disconnect(body):
	poscon = null
	conns.remove(conns.find(body))
	if flowing == true:
		Global_Variables.batteries[0].start_connecting()


func negative_connect(body):
	negcon =  body
	conns.append(body)
	if conns>1:
		Global_Variables.batteries[0].start_connecting()


func negative_disconnect(body):
	negcon = null
	conns.remove(conns.find(body))
	if flowing == true:
		Global_Variables.batteries[0].start_connecting()

