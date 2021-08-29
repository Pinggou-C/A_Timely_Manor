extends ColorRect
var size
var thickness

func _process(delta):
	material.Size = size
	material.Thickness = thickness
