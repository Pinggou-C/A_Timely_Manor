extends Spatial
var rng = RandomNumberGenerator.new()
func _ready():
	pass 

func drop(sped):
	get_parent().get_child(1).get_child(0).visible = false
	rng.randomize()
	var parent = get_parent()
	parent.friction = 1
	#get_parent().set_rough(true)
	#get_parent().bounce = 1
	#get_parent().set_absorbent(true)
	parent.linear_damp = 1
	parent.gravity_scale = 2
	parent.linear_velocity = sped
	var x = sqrt(sqrt(sped.x * sped.x))/2
	var y = sqrt(sqrt(sped.y * sped.y))/2
	var z = sqrt(sqrt(sped.z * sped.z))/2
	parent.angular_velocity = Vector3(rng.randfn(0, y),rng.randfn(0, z),rng.randfn(0, x))
func pickup():
	get_parent().get_child(1).get_child(0).visible = true
