extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var tween1
var tween2 


# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func velocity(which):
	if which == 0 || which == 2:
		tween1 = $ColorRect/Tween.interpolate_property($ColorRect, "self_modulate", $ColorRect.self_modulate, Color(1, 1, 1, 1), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN)                    
		$ColorRect/Tween.start()
		$AnimationPlayer.play("New Anim")
		print($ColorRect.material.get_shader_param('colour'))
		if $ColorRect/Tween2.is_active():
			$ColorRect/Tween2.stop_all()
	elif which == 1 || which == 3:
		tween2 = $ColorRect/Tween2.interpolate_property($ColorRect, "self_modulate", $ColorRect.self_modulate, Color(1, 1, 1, 0), 0.3, Tween.TRANS_LINEAR, Tween.EASE_IN) 
		$ColorRect/Tween2.start()
		$AnimationPlayer.stop()
		print($ColorRect.material.get_shader_param('colour'))
		if $ColorRect/Tween.is_active():
			$ColorRect/Tween.stop_all()
	if which == 4 || which == 2:
		$ColorRect/Tween3.interpolate_property($ColorRect.get_material(), "shader_param/colour", $ColorRect.material.get_shader_param('colour'), Vector3(-0.5, -0.2, 0.0), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN) 
		$ColorRect/Tween3.start()
		if $ColorRect/Tween4.is_active():
			$ColorRect/Tween4.stop_all()
		#$ColorRect.material.set_shader_param('colour', Vector3(-0.5, -0.2, 0.0))
	elif which == 5 || which == 0:
		$ColorRect/Tween4.interpolate_property($ColorRect.get_material(), "shader_param/colour", $ColorRect.material.get_shader_param('colour'), Vector3(-0.7, -0.7, -0.7), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN) 
		$ColorRect/Tween4.start()
		if $ColorRect/Tween3.is_active():
			$ColorRect/Tween3.stop_all()
		#$ColorRect.material.set_shader_param('colour', Vector3(-0.7, -0.7, -0.7))


