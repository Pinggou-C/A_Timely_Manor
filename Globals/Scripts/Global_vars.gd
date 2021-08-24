extends Node

var Time_Scale = 1

#can be -1, 0 & 1
func _process(_delta):
	if Input.is_action_just_pressed("mouse_l"):
		if Time_Scale != -1:
			yield(get_tree().create_timer(0.1), "timeout")
			if Time_Scale == 0:
				get_tree().call_group("effected", "velocity", 4)
			elif Time_Scale == 1:
				get_tree().call_group("effected", "velocity", 2)
			Time_Scale = -1
		else:
			yield(get_tree().create_timer(0.25), "timeout")
			Time_Scale = 1
			get_tree().call_group("effected", "velocity", 3)
	if Input.is_action_just_pressed("mouse_r"):
		if Time_Scale != 0:
			yield(get_tree().create_timer(0.1), "timeout")
			if Time_Scale == -1:
				get_tree().call_group("effected", "velocity", 5)
			elif Time_Scale == 1:
				get_tree().call_group("effected", "velocity", 0)
			Time_Scale = 0
		else:
			yield(get_tree().create_timer(0.25), "timeout")
			Time_Scale = 1
			get_tree().call_group("effected", "velocity", 1)

