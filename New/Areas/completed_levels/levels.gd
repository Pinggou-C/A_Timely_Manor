extends Spatial


export(int, 0, 99) var wires = 5
export(int, 0, 99) var nodes = 5
export(int, 0, 999) var resistances = 5

func info():
	return [wires, nodes, resistances]
