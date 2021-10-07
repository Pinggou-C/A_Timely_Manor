extends Node

class MyCustomSorter:
	static func sort_ascending(a, b):
		if a[0] < b[0]:
			return true
		return false

const MAX_COMPONENT_UPDATES_PER_FRAME = 20

var electrical_update_in_progress = false

var batteries = []

var updated_components = 0

var first_node
var errors = []
var starting_point 

var connecteds = []
var nodes = []
var conned_batteries = []
var connected_nodes = []
var un_connected_nodes = []
var paths = []
var valid_paths = []
var unvalid_paths = []
var flowing = false
var connected = false

func _ready():
	pass
 
func update_all_electrical_components():
	# This makes sure only one electrical update can be happening at once
	if electrical_update_in_progress:
		return 
	electrical_update_in_progress = true
	# Update all components, waiting for a frame every time the cap is reached
	var scene_tree = get_tree()
	var components_updated_this_frame = 0
	for i in scene_tree.get_nodes_in_group("electrical_components"):
		var p = i.conecteds()
		connecteds.append([p[0],p[1]])
		nodes.append(p[0])
		if p[0].is_in_group("batteries"):
			conned_batteries.append([p[0]])
		components_updated_this_frame += 1
		if components_updated_this_frame == MAX_COMPONENT_UPDATES_PER_FRAME:
			# Yield until the next physics frame, allowing other parts of your code to execute.	
			yield(scene_tree, "physics_frame") 
			# Or "idle_frame", depending on which suits your game better
			components_updated_this_frame = 0
	find_paths()
	electrical_update_in_progress = false

func find_paths():
	#the first the battery passes is always the positive connection point
	starting_point = conned_batteries[0]
	first_node = connecteds[nodes.find(starting_point)][1][0]
	var previous_node = starting_point
	var current_node = connecteds[nodes.find(starting_point)][1][0]
	path(current_node. previous_node, [previous_node])
	

func path(current, previous, path, res, old_res, node_ord):
	var current_node = current
	var revious_node = previous
	var next_nodes = connecteds[nodes.find(current_node)][1]
	var current_path = path
	var resistance = res
	var old_resistance = old_res
	var node_order  = node_ord
	current_path.append(current_node)
	for i in next_nodes:
		if !path.has(i):
			if i.is_in_group("batteries):
				if i == connecteds[nodes.find(starting_point)][1][1]:
					end_path(i, current_node, current_path, resistance, old_resistance, node_order)
			elif !nodes.find(previous_node)[1].has(i):
				if !nodes.find(first_node)[1].has(i):
					path(i, current_node, current_path, resistance, old_resistance, node_order)
				else:
					error.append[current_node, i, "to first node"]
			else:
				error.append[current_node, i, "to prefious node"]

func end_path(path):
	!if paths.has(path):
		paths.append(path)
