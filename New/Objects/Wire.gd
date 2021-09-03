extends RigidBody

export(String, "straight", "corner", "Tri" ,"Quad", "Quad_Overpass", "Quad_Cornerpass") var type

var conns = []
var poscon = false
var negcon = false
var flowing = false
var connected = false

var powered_by = []
var volts
var amps
var path0 =[]
var resistance0 =0
var oldresistance0 =[]
var splits0 =[]

func _ready():
	pass # Replace with function body.

func connecting(path, resistance, split, body, oldresistances):
	if connected == true:
		if path.has(self):
			return
		else:
			var which = -1
			var which2 = -1
			var rev = split.invert()
			for i in rev:
				var g = splits0.find(i)
				if g != -1:
					which = g
				var h = split.find(i)
				if h != -1:
					which2 = h
			if oldresistance0[which] == 0 && oldresistances[which2] != 0:
				Global_Variables.dead_routes.append(path0)
				return
			elif oldresistances[which2] == 0 && oldresistance0[which] != 0:
				path0 = path
				splits0 = split
				resistance0 = resistance
				oldresistance0 = resistance
				powered_by.append(body)
	else:
		var paths = path.append(self)
		path0 = path
		oldresistance0 = oldresistances
		splits0 = split
		resistance0 = resistance
		powered_by.append(body)
		var splits = split
		if conns > 2:
			splits.append(self)
		if conns.size > 1:
			for i in conns:
				if i != body:
					i.connecting(paths, resistance, splits, self, oldresistances)
			connected = true
		else:
			Global_Variables.dead_routes.append(paths)
			return

func middle_connect(body):
	if body.is_in_group("wires") && body != self:
		conns.append(body)
		if conns>1:
			Global_Variables.batteries[0].start_connecting()

func middle_disconnect(body):
	if body.is_in_group("wires") && body != self:
		if conns.has(body):
			conns.remove(conns.find(body))


func positive_connect(body):
	if body.is_in_group("wires") && body != self:
		poscon = body
		conns.append(body)
		if conns.size()>1:
			Global_Variables.batteries[0].start_connecting()


func positive_disconnect(body):
	if body.is_in_group("wires") && body != self:
		poscon = null
		conns.remove(conns.find(body))
		if flowing == true:
			Global_Variables.batteries[0].start_connecting()


func negative_connect(body):
	if body.is_in_group("wires") && body != self:
		negcon =  body
		conns.append(body)
		if conns.size()>1:
			Global_Variables.batteries[0].start_connecting()


func negative_disconnect(body):
	if body.is_in_group("wires") && body != self:
		negcon = null
		conns.remove(conns.find(body))
		if flowing == true:
			Global_Variables.batteries[0].start_connecting()

