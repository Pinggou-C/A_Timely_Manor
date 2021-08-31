extends StaticBody

var posconnect = false
var negconnect = false

var flowing = false

var paths = []
# paths = [ [id, resistance, [wires], [splits]], []]
var pathnr = 0
var resistance_l = 1000
var wires = []
var splits = []
export(float) var volts = 1
export(float) var amps = 1


func _ready():
	Global_Variables.batteries.append(self)

func start_connecting():
	posconnect.connecting([], 0, [], self)
#gets called when a sygnal returns
func connecting(path, resistance, split):
	if resistance_l != 1 || resistance == 0:
		for i in path:
			if wires.has(i) == false:
				wires.append(i)
		pathnr += 1
		path.insert(0, resistance)
		paths.append(path)
		for j in split:
			if splits.has(j) == false:
				splits.append(j)
#		if resistance == 0:
#			for h in paths:
#				if h[0] != 0:
#					paths.remove(paths.find(h))
#			resistance = resistance

func posdiscon(body):
	posconnect = null
	if flowing == true:
		flowing = false

func negcon(body):
	negconnect = body
	if posconnect != null:
		posconnect.connecting([], 0, [], self)
	#var group = get_tree().get_nodes_in_group('special')
	#for i in group:
	#	if i.posconnect == null || i.negconnect == null:
	#		return
	#posconnect.connecting([], 0, [])


func negdiscon(_body):
	negconnect = null
	if flowing == true:
		flowing = false



func poscon(body):
	posconnect = body
	if negconnect != null:
		posconnect.connecting([], 0, [], self)
	#gets all nodes which need to be connected properly and checks if they are
	#var group = get_tree().get_nodes_in_group('special')
	#for i in group:
	#	if i.posconnect == null || i.negconnect == null:
	#		return
	#posconnect.connecting([], 0, [])
		
