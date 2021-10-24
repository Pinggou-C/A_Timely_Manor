extends Spatial
var rng = RandomNumberGenerator.new()
var modee = "rigid"
export(int, 1, 1000) var weight = 100
func _ready():
	pass 

func drop(sped, wiresnap):
	#get_parent().get_child(1).get_child(0).visible = false
	rng.randomize()
	var parent = get_parent()
	parent.friction = 1
	#get_parent().set_rough(true)
	#get_parent().bounce = 1
	#get_parent().set_absorbent(true)
	parent.linear_damp = 1
	parent.gravity_scale = 2
	parent.linear_velocity = sped
	var x = sqrt(sqrt(sped.x * sped.x))/sqrt(weight)
	var y = sqrt(sqrt(sped.y * sped.y))/sqrt(weight)
	var z = sqrt(sqrt(sped.z * sped.z))/sqrt(weight)
	parent.angular_velocity = Vector3(rng.randfn(0, y),rng.randfn(0, z),rng.randfn(0, x))
func pickup():
	pass
	#get_parent().get_child(1).get_child(0).visible = true
