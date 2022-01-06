extends Spatial


export(int, 0, 25) var wires = 5
export(int, 0, 25) var nodes = 5
export(int, 0, 25) var resistances = 5

func info():
	return [wires, nodes, resistances]
