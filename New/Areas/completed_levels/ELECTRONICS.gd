extends Spatial

var wires = 0
var nodes = 0
func update(wirenode):
	if wirenode[0] != wires:
		wires = wirenode[0]
	if nodes != wirenode[1]:
		nodes = wirenode[1]
