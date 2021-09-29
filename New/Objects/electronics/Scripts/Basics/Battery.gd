extends StaticBody

var posconnect = null
var negconnect = null

var flowing = false

var all_paths = []
var paths = []
# paths = [ [id, resistance, [wires], [splits]], []]
var wires = []
var oldresistances = []
var splits = []
export(float) var volts = 1
export(float) var amps = 1


func _ready():
	Global_Variables.batteries.append(self)

func start_connecting(body = null):
	if posconnect != null && negconnect != null:
		print("print1")
		posconnect.connecting([], 0, self, [])
		$Timer.start(0.5)
#gets called when a sygnal returns
func connecting(path, resistance, body, oldresistance):
	print("print5")
	if Global_Variables.paths.size() > 0:
		#print(Global_Variables.paths.size())
		for j in Global_Variables.paths:
			#var splitt = j['splits']
			var which = -1
			var which2 = -1
			#if split.size() > 0:
			#	var rev = split
			#	rev.invert()
			#	for i in rev:
			#		var g = splitt.find(i)
			#		if g != -1:
			#			which = g
			#			var h = split.find(i)
			#			if h != -1:
			#				which2 = h
						#if oldresistance[which] == 0 && j["oldresistances"][which2] != 0:
							#Global_Variables.paths.remove(Global_Variables.paths.find(j))
							#Global_Variables.dead_paths.append(j)
						#elif j["oldresistances"][which2] == 0 && oldresistance[which] != 0:
							#return
	for i in path:
		if wires.has(i) == false:
			wires.append(i)
	all_paths.append({"path":path, 'resistance':resistance,'oldresistances':oldresistance})
	var dict = {"path":path, 'resistance':resistance,'oldresistances':oldresistance}
	print(dict)
	for i in Global_Variables.paths:
		if i["path"] != dict["path"]:
			Global_Variables.paths.append(dict)
	if resistance == 0:
		for h in Global_Variables.paths:
			if h['resistance'] != 0:
				Global_Variables.dead_routes.append(h)
				Global_Variables.paths.remove(Global_Variables.paths.find(h))

func posdiscon(body):
	if body.is_in_group('wire_end'):
		posconnect = null
		if flowing == true:
			flowing = false

func negcon(body):
	if body.is_in_group('wire_end'):
		if body.is_in_group("wire_front_end"):
			negconnect = body.get_parent().rearnode
		else:
			negconnect = body.get_parent().frontnode


func negdiscon(body):
	if body.is_in_group('wire_end'):
		negconnect = null
		if flowing == true:
			flowing = false


func poscon(body):
	if body.is_in_group('wire_end'):
		if body.is_in_group("wire_front_end"):
			posconnect = body.get_parent().rearnode
		else:
			posconnect = body.get_parent().frontnode


func _on_Timer_timeout():
	var rev = Global_Variables.paths
	print("print3")

func cunn(node, body2):
	if posconnect == body2:
		posconnect = node
	elif negconnect == body2:
		negconnect = node