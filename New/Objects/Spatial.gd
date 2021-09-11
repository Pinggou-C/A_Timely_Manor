extends Spatial


var rng = RandomNumberGenerator.new()

export(String, "straight", "corner", "Tri" ,"Quad", "Quad_Overpass", "Quad_Cornerpass") var type

var printtt = 0
var conns = []
var poscon = false
var negcon = false
var flowing = false
var connected = false

var pickedup = false

var powered_by = []
var volts
var amps
var path0 =[]
var resistance0 =0
var oldresistance0 =[]
var splits0 =[]

func _ready():
	pass 

func connecting(path, resistance, split, body, oldresistances):
	var stop = false
	if connected == true:
		if path.has(self):
			print("dead")
			stop = true
			return
		else:
			var which = -1
			var which2 = -1
			if split.size()> 0:
				var rev = split
				rev.invert()
				for i in rev:
					var g 
					if splits0.has(i):
						g = splits0.find(i)
						if g != -1:
							which = g
						var h 
						if split.has(i):
							h = split.find(i)
							if h != -1:
								which2 = h
							#if oldresistance0[which] == 0 && oldresistances[which2] != 0:
							#	Global_Variables.dead_routes.append(path0)
							#	return
							#if oldresistances[which2] == 0 && oldresistance0[which] != 0:
							#	path0 = path
							#	splits0 = split
							#	resistance0 = resistance
							#	oldresistance0 = resistance
							#powered_by.append(body)
	#else:
		if stop == false:
			var paths = path
			paths.append(self)
			path0 = path
			oldresistance0 = oldresistances
			splits0 = split
			resistance0 = resistance
			powered_by.append(body)
			var splits = split
			if conns.size() > 2:
				splits.append(self)
			if conns.size() > 1:
				for i in conns:
					if !i.is_in_group("bat"):
						if i != body:
							i.connecting(paths, resistance, splits, self, oldresistances)
					elif i.get_parent().get_parent() != body:
						i.get_parent().get_parent().connecting(paths, resistance, splits, self, oldresistances)
				connected = true
			else:
				Global_Variables.dead_paths.append(paths)
				if path.size() > 0:
					for i in path:
						i.connected = false
				stop = true
				print("dead2")
				#return
	else:
		if path.has(self):
			stop = true
			print("dead")
			return
		if stop == false:
			var paths = path
			paths.append(self)
			path0 = path
			oldresistance0 = oldresistances
			splits0 = split
			resistance0 = resistance
			powered_by.append(body)
			var splits = split
			if conns.size() > 2:
				splits.append(self)
				oldresistances.append(0)
			if conns.size() > 1:
				for i in conns:
					if !i.is_in_group("bat"):
						if i != body:
							i.connecting(paths, resistance, splits, self, oldresistances)
					elif i.get_parent().get_parent() != body:
						i.get_parent().get_parent().connecting(paths, resistance, splits, self, oldresistances)
				connected = true
			else:
				Global_Variables.dead_paths.append(paths)
				if path.size() > 0:
					for i in path:
						i.connected = false
				stop = true
				print("dead2")
				#return

func middle_connect(id, body, shape, localshape):
	if (body.is_in_group("wires")||body.is_in_group("wires2")) && body != get_parent():
		conns.append(body.get_child(0))
		if conns.size()>1:
			if pickedup != true:
				Global_Variables.batteries[0].start_connecting(self)

func middle_disconnect(id, body, shape, localshape):
	if (body.is_in_group("wires")||body.is_in_group("wires2")) && body != get_parent():
		if conns.has(body.get_child(0)):
			conns.remove(conns.find(body.get_child(0)))


func positive_connect(id, body, shape, localshape):
	if (body.is_in_group("wires")||body.is_in_group("wires2")) && body != get_parent():
		poscon = body.get_child(0)
		print("hi")
		conns.append(body.get_child(0))
		if conns.size()>1:
			if pickedup != true:
				print(body.get_child(0))
				Global_Variables.batteries[0].start_connecting(self)


func positive_disconnect(id, body, shape, localshape):
	if (body.is_in_group("wires")||body.is_in_group("wires2")) && body != get_parent():
		poscon = null
		print("disc")
		conns.remove(conns.find(body.get_child(0)))
		if flowing == true:
			if pickedup != true:
				Global_Variables.batteries[0].start_connecting(self)


func negative_connect(id, body, shape, localshape):
	if (body.is_in_group("wires")||body.is_in_group("wires2"))  && body != get_parent():
		negcon =  body.get_child(0)
		print("hi")
		conns.append(body.get_child(0))
		if conns.size()>1:
			if pickedup != true:
				print(body.get_child(0))
				Global_Variables.batteries[0].start_connecting(self)


func negative_disconnect(id, body, shape, localshape):
	if (body.is_in_group("wires")||body.is_in_group("wires2")) && body != get_parent():
		negcon = null
		print("disc")
		conns.remove(conns.find(body.get_child(0)))
		if flowing == true:
			if pickedup != true:
				Global_Variables.batteries[0].start_connecting(self)





func drop(sped):
	rng.randomize()
	pickedup = false
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
	pickedup = true

func trans_body(to: PhysicsBody, from: PhysicsBody) -> void:
	to.transform = from.transform
	from.replace_by(to)
	from.queue_free()

# Convert a `RigidBody` scene node to `KinematicBody`
func rigid_to_stat(rigid: RigidBody) -> StaticBody:
	var stat := StaticBody.new()
	trans_body(stat, rigid)
	return stat

# Convert a `KinematicBody` scene node to `RigidBody`
func stat_to_rigid(stat: StaticBody) -> RigidBody:
	var rigid := RigidBody.new()
	trans_body(rigid, stat)
	return rigid

func rigid_to_kinem(rigid: RigidBody) -> KinematicBody:
	var kinem := KinematicBody.new()
	trans_body(kinem ,rigid)
	return kinem

# Convert a `KinematicBody` scene node to `RigidBody`
func kinem_to_rigid(kinem: KinematicBody) -> RigidBody:
	var rigid := RigidBody.new()
	trans_body(rigid, kinem)
	return rigid

func kinem_to_stat(kinem: KinematicBody) -> StaticBody:
	var stat := StaticBody.new()
	trans_body(stat, kinem)
	return stat

func stat_to_kinem(stat: StaticBody) -> KinematicBody:
	var kinem := KinematicBody.new()
	trans_body(kinem, stat)
	return kinem


