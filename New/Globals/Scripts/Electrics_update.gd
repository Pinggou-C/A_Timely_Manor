extends Node

const MAX_COMPONENT_UPDATES_PER_FRAME = 10

var electrical_update_in_progress = false

var updated_components = 0

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
	for component in scene_tree.get_nodes_in_group("electrical"):
		component.update()
		components_updated_this_frame += 1
		if components_updated_this_frame == MAX_COMPONENT_UPDATES_PER_FRAME:
			# Yield until the next physics frame, allowing other parts of your code to execute.	
			yield(scene_tree, "physics_frame") 
			# Or "idle_frame", depending on which suits your game better
			components_updated_this_frame = 0
	electrical_update_in_progress = false
