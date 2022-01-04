tool
extends Spatial


export(int, "Wire", "battery", "node", 'lamp', "resistance") var what = 0 setget node
export(float, 0, 100, 0.1) var amp = 0 setget amp
export(float, 0, 100, 0.1) var volt = 0 setget volt
export(float, 0, 100, 0.1) var res = 0 setget res
export(float, 0, 10000, 0.1) var watt = 0 setget watt

var child
var childtype
func update_child():
	if child != null:
		child.queue_free()
		child = null
		childtype = null
	if what == 0:
		var nod = load("res://Objects/electronics/Items/Basics/goodwire.tscn")
		var nod2 = nod.instance()
		child = nod2
		childtype = "wire"
		add_child(nod2)
	elif what == 1:
		var nod = load("res://Objects/electronics/Items/Basics/Battery.tscn")
		var nod2 = nod.instance()
		nod2.amps = amp
		nod2.volts = volt
		child = nod2
		childtype = "bat"
		add_child(nod2)
	elif what == 2:
		var nod = load("res://Objects/electronics/Items/Basics/Wirenode.tscn")
		var nod2 = nod.instance()
		child = nod2
		childtype = "node"
		add_child(nod2)
	elif what == 3:
		var nod = load("res://Objects/electronics/Items/Lamp.tscn")
		var nod2 = nod.instance()
		nod2.volt_needs = volt
		nod2.watt_needs = watt
		nod2.resistance = res
		child = nod2
		childtype = "lamp"
		add_child(nod2)
	elif what == 4:
		var nod = load("res://Objects/electronics/Items/Complex/Resistance.tscn")
		var nod2 = nod.instance()
		nod2.resistance = res
		child = nod2
		childtype = "res"
		add_child(nod2)

func node(new):
	what = new
	update_child()

func watt(new):
	watt = new
	if child != null && childtype == "lamp":
		child.watt_needs = watt

func volt(new):
	volt = new
	if child != null:
		if childtype == "lamp":
			child.volt_needs = volt
		if childtype == "bat":
			child.volts = volt


func amp(new):
	amp = new
	if child != null:
		if childtype == "bat":
			child.amps = amp


func res(new):
	res = new
	if child != null:
		if childtype == "lamp" || childtype == "res":
			child.resistance = res
	
