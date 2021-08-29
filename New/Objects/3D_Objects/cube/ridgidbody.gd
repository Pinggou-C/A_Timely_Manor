extends Spatial
var rng = RandomNumberGenerator.new()
var loc = []
var deg = []
var velocity2 = Vector3()
var angvelocity = Vector3()
var touchplayer = false
var playerhold = false
var Time_Scale = Global_Variables.Time_Scale
onready var parent = get_parent()

func _physics_process(_delta):
	#add_force(Vector3(1, 1, 1), Vector3(-1, 0.1, 1))
	parent = get_parent()
	if  Global_Variables.Time_Scale == 0 || Global_Variables.Time_Scale == 1 || playerhold == true:
		loc.append(parent.global_transform.origin)
		deg.append(parent.rotation_degrees)
	elif  Global_Variables.Time_Scale == -1 && playerhold == false:
		if loc.size() > 0 && deg.size() > 0:
			while loc[loc.size()-1] == loc[loc.size()-2] && deg[deg.size()-1] == deg[deg.size()-2] && loc.size() > 1 && deg.size() > 1:
				loc.remove(loc.size()-1)
				deg.remove(deg.size()-1)
			parent.translation = loc[loc.size()-1]
			parent.global_transform.origin = lerp(parent.global_transform.origin, loc[loc.size()-1], 0.0333)
			parent.rotation_degrees = deg[deg.size()-1]
			parent.rotation_degrees = lerp(parent.rotation_degrees, deg[deg.size()-1], 0.0333)
			loc.remove(loc.size()-1)
			deg.remove(deg.size()-1)
	elif  Global_Variables.Time_Scale == 0 && playerhold == true:
		loc.append(parent.global_transform.origin)
		deg.append(parent.rotation_degrees)
		
func hold(_onof):
	pass

func velocity(which):
	if which == 0 || which == 5:
		if playerhold == false:
			velocity2 = parent.linear_velocity
			angvelocity = parent.angular_velocity
			$Tween.interpolate_property(parent, 'linear_velocity', parent.linear_velocity, Vector3(0, 0, 0), 0.333, Tween.TRANS_LINEAR, Tween.EASE_IN)
			$Tween.start()
			$Tween2.interpolate_property(parent, 'angular_velocity', parent.angular_velocity, Vector3(0, 0, 0), 0.333, Tween.TRANS_LINEAR, Tween.EASE_IN)
			$Tween2.start()
			parent.gravity_scale = 0
			parent.set_mode(RigidBody.MODE_KINEMATIC)
		else:
			pass
	elif which == 1 || which == 3:
		if playerhold == false:
			parent.gravity_scale = 2
			parent.linear_velocity = Vector3(0, 0.1, 0)
			parent.set_mode(RigidBody.MODE_RIGID)
			parent.apply_impulse(Vector3(0, 0, 0), Vector3(0.1, 0.1, 0.1))
	elif which == 2 || which == 4:
		if playerhold == false:
			parent.set_mode(RigidBody.MODE_KINEMATIC)
			parent.gravity_scale = 0
	if which == 1:
		if playerhold == false:
			$Tween2.interpolate_property(parent, 'angular_velocity', parent.angular_velocity, angvelocity, 0.333, Tween.TRANS_LINEAR, Tween.EASE_IN)
			$Tween2.start()
			if velocity2 != Vector3(0, 0, 0):
				$Tween.interpolate_property(parent, 'linear_velocity', parent.linear_velocity, velocity2, 0.333, Tween.TRANS_LINEAR, Tween.EASE_IN)
				$Tween.start()

func pickup():
	playerhold = true
	get_parent().get_child(1).get_child(0).visible = true
func drop(sped):
	rng.randomize()
	get_parent().get_child(1).get_child(0).visible = false
	playerhold = false
	yield(get_tree().create_timer(0.02), "timeout")
	parent = get_parent()
	parent.friction = 1
	parent.linear_damp = 1
	if Global_Variables.Time_Scale == 1:
		parent.gravity_scale = 2
		parent.apply_impulse(Vector3(0, 0, 0), Vector3(0.01, 0.01, 0.01))
	elif Global_Variables.Time_Scale == 0:
		parent.gravity_scale = 0
		parent.set_mode(RigidBody.MODE_KINEMATIC)
		velocity2 = parent.linear_velocity
		angvelocity = parent.angular_velocity
	elif Global_Variables.Time_Scale == -1:
		parent.gravity_scale = 0
		parent.set_mode(RigidBody.MODE_KINEMATIC)
	parent.linear_velocity = sped
	print(sped)
	var x = sqrt(sqrt(sped.x * sped.x))/2
	var y = sqrt(sqrt(sped.y * sped.y))/2
	var z = sqrt(sqrt(sped.z * sped.z))/2
	parent.angular_velocity = Vector3(rng.randfn(0, y),rng.randfn(0, z),rng.randfn(0, x))
	
	#parent.rough = true
	#parent.bounce = 1
	#parent.absorbent = true



