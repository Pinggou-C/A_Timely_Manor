extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	print(OS.get_window_size()/2)
	position = Vector2(2560, 1600)/2
	pass
