extends StaticBody

var posconnect = false
var negconnect = false

var flowing = false

var paths = []
# paths = [ [id, resistance, [wires], [splits]], []]
var wires = []
var oldresistances = []
var splits = []
export(float) var volts = 1
export(float) var amps = 1


func _ready():
	Global_Variables.batteries.append(self)

func start_connecting():
	posconnect.connecting([], 0, [], self)
#gets called when a sygnal returns
func connecting(path, resistance, split, body, oldresistance):
	
	for i in path:
		if wires.has(i) == false:
			wires.append(i)
	paths.append(path)
	path.insert(0, resistance)
	Global_Variables.routes.append(path)
	Global_Variables.all_routes.append(path)
	for i in split:
		if !Global_Variables.splits.has(i):
			Global_Variables.splits.append(i)
	for j in split:
		if splits.has(j) == false:
			splits.append(j)
	if resistance == 0:
		for h in Global_Variables.routes:
			if h[0] != 0:
				Global_Variables.dead_routes.append(h)
				Global_Variables.routes.remove(Global_Variables.routes.find(h))

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
		
