extends Spatial

onready var path  = get_path()

func _ready():
	print(path)


func load_children():
	pass


func unload_children():
	pass
