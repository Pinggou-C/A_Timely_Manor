extends Camera
 
func _process(_delta):
	get_tree().call_group("mirror", "update_cams", global_transform)
