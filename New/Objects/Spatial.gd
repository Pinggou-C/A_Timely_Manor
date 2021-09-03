extends Spatial


var rng = RandomNumberGenerator.new()
func _ready():
	pass 

func drop(sped):
	rng.randomize()
	var parent = get_parent()
	parent.friction = 1
	#get_parent().set_rough(true)
	#get_parent().bounce = 1
	var script = load("res://Objects/Wire.gd")
	parent.set_script(script)
	#get_parent().set_absorbent(true)
	parent.linear_damp = 1
	parent.gravity_scale = 2
	parent.linear_velocity = sped
	var x = sqrt(sqrt(sped.x * sped.x))/2
	var y = sqrt(sqrt(sped.y * sped.y))/2
	var z = sqrt(sqrt(sped.z * sped.z))/2
	parent.angular_velocity = Vector3(rng.randfn(0, y),rng.randfn(0, z),rng.randfn(0, x))
func pickup():
	pass
