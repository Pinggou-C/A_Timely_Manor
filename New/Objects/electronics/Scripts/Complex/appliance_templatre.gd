extends Spatial

#  the paths passed through the power function have a very specific format
#  This format goes as follows, its an array with many path arrays inside it
#  these follow this structure
#  [splitoffpoint(node), conbinationpoint(node), path(an array), resistance
#(core path, current path, splits array[], deverge array[[split, [[pathid, unique bit, resistance, cenverge],[],[]]],[split2, [[pathid, unique bit, resistance, cenverge],[],[]]]], conferge, paths(sorted by pathid)
#

export(float) var resistance
export(float, 0.1, 100, 0.1) var volts
export(float, 0.01, 100, 0.1) var watts

var wire_amps = null
var wire_volts = null
var wire_path = null

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
