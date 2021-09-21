extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func save():
	pass

#loads an area and instances all levels in it
func Loadarea(area):
	var path = "res://Level_creator/Areas"
	path += "/area"+String(area)+".tscn"
	var nod = load(path)
	var arr = nod.instance()
	get_tree().get_root().add_child(arr)
	arr.load_childer()

#unloads an area removing all levels
func unLoadarea(area):
	area.unload_children()


func Load(node, area):
	var path = "res://Level_creator/Areas"
	path += "/area"+String(area)+"/Levels"
	path +="level"+String(node)+".tscn"
	print(path)
	var nod = load(path)
	var lev = nod.instance()
	get_tree().get_root().add_child(lev)
	lev.global_transform.origin = lev.poss

func unLoad(node):
	pass
