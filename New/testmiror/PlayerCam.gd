extends Camera
onready var blur = preload("res://shader+addons/motion_blur/motion_blur.tscn")

func _process(_delta):
	get_tree().call_group("mirror", "update_cams", global_transform)

func _ready():
	set_process(false)
	if Global_Settings.motionblur == true:
		var bb = blur.instance()
		add_child(bb)
	
