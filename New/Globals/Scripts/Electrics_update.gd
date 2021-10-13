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
var errorid = []
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

var main_path
var path_bits = []

func _ready():
	pass
 
func update_all_electrical_components():
	print("hi")
	# This makes sure only one electrical update can be happening at once
	if electrical_update_in_progress:
		return 
	electrical_update_in_progress = true
	# Update all components, waiting for a frame every time the cap is reached
	var scene_tree = get_tree()
	var components_updated_this_frame = 0
	var nodestuff = []
	var specialnodestuf = []
	var allnode = []
	for i in scene_tree.get_nodes_in_group("electrical_components"):
		if i.is_in_group("batteries") || i.is_in_group("appliance"):
			var p =i.conecteds()
			if p[2] != "error":
				specialnodestuf.append(p)
				allnode.append(i)
				print(p)
		else:
			var p =i.conecteds()
			if p[2] != "error":
				nodestuff.append(p)
				allnode.append(i)
				print(p)
	#checks batteries, appliances and one way things
	
	for i in specialnodestuf:
		print("hellotherr")
		var p = i
		var err = false
		var nodes = p[1]
		if !errorid.has(p[0]):
			for node in nodes:
				if allnode.has(node):
					if node.is_in_group("batteries") || node.is_in_group("appliance"):
						var front = nodestuff[allnode.find(node)][1][0]
						var rear = nodestuff[allnode.find(node)][1][1]
						var side
						if p[0] == front:
							side = "front"
						elif p[0] == rear:
							side = "rear"
						if p[1][0] == node && side == "front":
							errors.append([i, node, "facing towards"])
							errorid.append(node)
							err = true
						elif p[1][1] == node && side == "rear":
							errors.append([i, node, "facing towards"])
							errorid.append(node)
							err = true
				else:
					errors.append([i, node, "non existant"])
					errorid.append(i)
					err = true
		if err == false:
			connecteds.append([p[0], [p[1][0]], p[2], p[3], p[1]])
			print(p[1][0])
			print([p[0], [p[1][0]], p[2], p[3], p[1]])
			nodes.append(p[0])
			print("hiii")
			if p[0].is_in_group("batteries"):
				conned_batteries.append([p[0]])
		components_updated_this_frame += 1
		if components_updated_this_frame == MAX_COMPONENT_UPDATES_PER_FRAME:
			# Yield until the next physics frame, allowing other parts of your code to execute.	
			yield(scene_tree, "physics_frame") 
			# Or "idle_frame", depending on which suits your game better
			components_updated_this_frame = 0
	for i in nodestuff:
		print("hellotherr2")
		var p = i
		var err = false
		var points = []
		var all_points = []
		var nodes = p[1]
		for node in nodes:
			if allnode.has(node):
				if node.is_in_group("batteries") || node.is_in_group("appliance"):
					var front = nodestuff[allnode.find(node)][1][0]
					var rear = nodestuff[allnode.find(node)][1][1]
					if errorid.has(node) || errorid.has(front) || errorid.has(rear):
						err = true
					if err == false:
						if p[0] != front:
							points.append(node)
						all_points.append(node)
				else:
					all_points.append(node)
			else:
				errors.append([i, node, "non existant"])
				errorid.append(i)
		if all_points.size()> 1:
			connecteds.append([p[0], points, p[2], p[3], all_points])
			nodes.append(p[0])
			print("hiii")
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
	print("find")
	starting_point = conned_batteries[0][0]
	print(conned_batteries)
	first_node = connecteds[nodes.find(starting_point)][4][0]
	var previous_node = starting_point
	var current_node = connecteds[nodes.find(starting_point)][4][0]
	print(connecteds[nodes.find(starting_point)])
	path(current_node, previous_node, null, [previous_node], 0, [], ["battery"], [])
	

func path(current, previous,prev_proper, path, res, old_res, node_ord, splits):
	print("find2")
	var current_node = current
	var previous_node = previous
	var next_nodes = connecteds[nodes.find(current_node)][1]
	var current_path = path
	var splits_new = splits
	var resistance = res
	var node_order  = node_ord
	node_order.append(connecteds[nodes.find(current_node)][2])
	var prev_normal_node = prev_proper
	var new_paths = []
	current_path.append(current_node)
	print(next_nodes)
	for i in next_nodes:
		print("test")
		if !path.has(i):
			print("test")
			var id = connecteds[nodes.find(i)]
			var curpath = current_path
			if id[2] == "battery":
				node_order.append("battery")
				if i == connecteds[nodes.find(starting_point)][1][1]:
					end_path(i,current_path, node_order, old_res, resistance)
				new_paths.append(i, curpath.append(i), "battery", 0, old_res)
			elif !connecteds[nodes.find(prev_normal_node)][1].has(i):
				var nod_or = node_order
				var cur_path = path
				if !connecteds[nodes.find(first_node)][1].has(i):
					print("test")
					if id[2] == "node":
						new_paths.append(i, curpath.append(i), "node", 0, old_res)
					if id[2] == "appliance":
						var old_resistance = old_res
						var ress = id[3]
						old_resistance.append(ress)
						if current == id[1][0]:
							new_paths.append(i, curpath.append(i), "appliance", ress, old_resistance)
						else:
							errors.append([current_node, i, "wrong entrance"])
					if id[2] == "non_appliance":
						new_paths.append(i, curpath.append(i), "non_appliance", 0, old_res)
				else:
					errors.append([current_node, i, "to first node"])
			else:
				errors.append([current_node, i, "to prefious node"])
	if new_paths.size() > 1:
		splits_new.append(current_node)
		prev_normal_node = current_node
	for i in new_paths:
		path(i[0], current_node, prev_normal_node, i[1], i[3], i[4], node_order, splits_new)



func end_path(node, path, node_ord, old_res, res):
	var tot_path = {"path":path, "node_order":node_ord, "old_resistance":old_res, "resistance":res}
	if !paths.has(tot_path):
		for i in paths:
			if i["resistance"] == 0 && res != 0:
				pass
			elif i["resistance"] != 0 && res == 0:
				paths.append(tot_path)
				paths.remove(paths.find(i))
			else:
				paths.append(tot_path)
