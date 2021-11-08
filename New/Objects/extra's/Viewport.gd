tool
extends Viewport

export(float, 0, 100) var sizee = 1 setget set_size
export(String, MULTILINE) var text setget text_set
export(int, 1, 64) var fontsize
func ready():
	$Label.text = text

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
func text_set(new_value):
	text = new_value
	$Label.text = new_value
	sizee = $Label.rect_size

func set_size(new_value):
	sizee = new_value
	#get_parent().scale = Vector3(sizee, sizee, sizee)

func _process(delta):
	
	pass
