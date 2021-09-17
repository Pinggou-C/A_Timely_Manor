extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	print(OS.get_window_size()/2)
	position = OS.get_window_size()/2
	pass
