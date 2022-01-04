extends KinematicBody

var wiresnap = false

var looking_at = null
var temp_look
var all_looks = []

var gravity = Vector3.DOWN * 18
var speed  = 4.5
var jump_speed  = 7
var spin = 0.07
var jump
var mouseDelta:Vector2 = Vector2()
var oldvelocety = Vector3()
var velocety = Vector3()
var mass = 80
var picked = false
var pick = null
var rel_pos
var pickvel = Vector3(0, 0, 0)
var pickgroups = []

#info
var wires
var nodes
var resistances

func _ready():
	var info = get_parent().info()
	wires = info[0]
	nodes = info[1]
	resistances = info[2]

func _physics_process(delta):
	if (velocety.y >= -0.01 && velocety.y <= 0.01 )&& oldvelocety.y <-12:
		print(oldvelocety.y)
	if $AudioStreamPlayer3D.stream_paused == true && ((velocety.x >=1 || velocety.x <=-1) || (velocety.z >=1 || velocety.z <=-1)) && is_on_floor():
		$AudioStreamPlayer3D.stream_paused = false
	if ((velocety.x <=1 && velocety.x >=-1) && (velocety.z <=1 && velocety.z >=-1)) || !is_on_floor():
		$AudioStreamPlayer3D.stream_paused = true
	oldvelocety = velocety
	velocety += gravity * delta
	get_input()
	velocety = move_and_slide(velocety, Vector3.UP, false, 4, PI/4, false)
	
	#var hi = get_slide_count()
	#for i in hi:
	#	var gi = get_slide_collision(i)
	#	var ci = gi.collider
	#	if ci.is_in_group("movable"):
	#		ci.add_force(velocety.normalized() , translation)
	#if pick != null:
	#	pick.global_transform = $RayCast/Position3D.global_transform
	#	pick.rotation_degrees = rotation_degrees
	if jump && is_on_floor():
		velocety.y = jump_speed
	if pick == null:
		return
	var pos_cur = pick.get_global_transform().origin
	var angle = Vector3($Head.rotation_degrees.x, rotation_degrees.y, 0)*PI/180
	#print((Vector3(rel_pos * sin(angle.y) * cos(angle.x), rel_pos * sin(angle.y) * sin(angle.x), rel_pos * cos(angle.y))))
	#var pos_next = ($Head.get_global_transform().origin + (Vector3(rel_pos * sin(angle.y) * cos(angle.x), rel_pos * sin(angle.y) * sin(angle.x), rel_pos * cos(angle.y))))
	var pos_next = ($Head.get_global_transform() * rel_pos).origin
	#print(rel_pos.origin)
	if pick.is_in_group("wire_end"):
		if pick.snap_to_node == true:
			var p = pick.targetpos - pos_next
			if sqrt(pow(p.x, 2)+pow(p.y, 2)+pow(p.z, 2)) > 0.25:
				var vel = (pos_next - pos_cur) / delta
				pickvel = pick.move_and_slide(vel, Vector3.UP, false, 4, PI/4, true)
		else:
			var vel = (pos_next - pos_cur) / delta
			pickvel = pick.move_and_slide(vel, Vector3.UP, false, 4, PI/4, true)
	else:
		if !pickgroups.has("wire_nodes"):
			if wiresnap == true:
				pos_next = Vector3(stepify(pos_next.x, 0.5),stepify(pos_next.y, 0.5),stepify(pos_next.z, 0.5))
		var vel = (pos_next - pos_cur) / delta
		pickvel = pick.move_and_slide(vel, Vector3.UP, false, 4, PI/4, true)


func get_input():
	if picked == true:
		if Input.is_action_just_pressed("mouse_r"):
			if !pickgroups.has("wire_nodes"):
				var gg = floor(pick.rotation_degrees.y)
				if gg > 0:
					var i = 0
					while i < gg:
						gg-=1
						pick.rotation_degrees.y -= 360
				$Tween.interpolate_property(pick, "rotation_degrees:y", pick.rotation_degrees.y, pick.rotation_degrees.y + 90 , 0.15, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
				$Tween.start()
		elif Input.is_action_just_pressed("mouse_l"):
			if !pickgroups.has("wire_nodes"):
				var gd = floor(pick.rotation_degrees.y)
				if gd > 0:
					var j = 0
					while j < gd:
						gd-=1
						pick.rotation_degrees.z -= 360
				$Tween2.interpolate_property(pick, "rotation_degrees:z", pick.rotation_degrees.z, pick.rotation_degrees.z+90 , 0.15, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
				$Tween2.start()
	var vc = velocety.y
	velocety = lerp(velocety, Vector3(), 0.15)
	if Input.is_action_pressed("ui_left"):
		velocety = lerp(velocety, -transform.basis.x * speed, 0.15)
	elif Input.is_action_pressed("ui_right"):
		velocety = lerp(velocety, transform.basis.x * speed, 0.15)
	if Input.is_action_pressed("ui_down"):
		velocety = lerp(velocety, transform.basis.z * speed, 0.15)
	elif Input.is_action_pressed("ui_up"):
		velocety = lerp(velocety, -transform.basis.z * speed, 0.15)
	if Input.is_action_just_pressed("wiresnap"):
		if wiresnap == true:
			wiresnap = false
		elif wiresnap == false:
			wiresnap = true
		
	velocety.y = vc
	jump = false
	if Input.is_action_just_pressed("jump"):
		jump = true
	if Input.is_action_just_pressed("grab"):
		if picked == false:
			if $RayCast.is_colliding():
				var coll = $RayCast.get_collider()
				pick = coll
				var gooo = pick.rotation_degrees
				rel_pos = get_rel_pos(pick)
				if pick.is_in_group("wires"):
					pickgroups.append("wires")
					pick.get_child(0).pickup()
				if pick.is_in_group("wire_nodes"):
					pick.pickup()
					pickgroups.append("wire_nodes")
					picked = true
				else:
					if pick.get_child(0).modee == "rigid":
						var body := rigid_to_kinem(pick)
						pick = body 
						picked = true
						var gii = Vector3(stepify(gooo.x, 90),stepify(gooo.y, 90),stepify(gooo.z, 90))
						print(gii)
						pick.set_collision_layer_bit(3, true)
						$Tween.interpolate_property(pick, "rotation_degrees", gooo, gii, 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
						$Tween.start()
					elif pick.get_child(0).modee == "static":
						var body := stat_to_kinem(pick)
						pick = body 
						picked = true
						var gii = Vector3(stepify(gooo.x, 90),stepify(gooo.y, 90),stepify(gooo.z, 90))
						pick.set_collision_layer_bit(3, true)
						$Tween.interpolate_property(pick, "rotation_degrees", gooo, gii, 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
						$Tween.start()
		elif picked == true:
			if pickgroups.has("wire_nodes"):
				picked = false
				pick.drop(pickvel * 0.5, wiresnap)
				pick = null
				pickgroups = []
			else:
				if wiresnap == true:
					var body := kinem_to_stat(pick)
					body.set_collision_layer_bit(19, true)
					body.get_child(0).drop(pickvel * 0.75, wiresnap)
					pick = null
					picked = false
					for i in pickgroups:
						if i == "wires":
							body.set_collision_layer_bit(3, true)
						body.add_to_group(i)
				else:
					var body := kinem_to_rigid(pick)
					body.linear_velocity = pickvel / 1500
					body.set_collision_layer_bit(19, true)
					body.get_child(0).drop(pickvel * 0.75, wiresnap)
					pick = null
					picked = false
					for i in pickgroups:
						if i == "wires":
							body.set_collision_layer_bit(3, true)
						body.add_to_group(i)
				pickgroups = []


func _input(event):
	if event is InputEventMouseMotion:
		mouseDelta = event.relative
		
		##$Camera.rotation_degrees.z  += event.relative.z

func _process(_delta):
	$Camera.rotation_degrees.x = lerp($Camera.rotation_degrees.x, $Camera.rotation_degrees.x - mouseDelta.y, 0.5)
	$Camera.rotation_degrees.x = clamp($Camera.rotation_degrees.x, -89, 89) 
	rotation_degrees.y = lerp(rotation_degrees.y, rotation_degrees.y - mouseDelta.x, 0.5)
	mouseDelta = Vector2()
	$Head.rotation_degrees.x = lerp($Head.rotation_degrees.x, $Camera.rotation_degrees.x, 0.33)
	$RayCast.rotation_degrees.x = lerp($RayCast.rotation_degrees.x, $Camera.rotation_degrees.x, 0.33)
	$Area.rotation_degrees.x = lerp($Area.rotation_degrees.x, $Camera.rotation_degrees.x, 0.33)

# Get the `Transform` of a `PhysicsBody` relative to the player position
func get_rel_pos(body):
	var pos = $Head.get_global_transform().origin - body.get_global_transform().origin
	var pos3 = (sqrt(pow(pos.x, 2)+pow(pos.y, 2)+pow(pos.z, 2)))
	var angle = Vector3($Head.rotation_degrees.x, rotation_degrees.y, 0)*PI/180
	print(Vector3(pos3 * sin(angle.x) * cos(angle.y), pos3 * sin(angle.x) * sin(angle.y), pos3 * cos(angle.x)))
	return $Head.get_global_transform().inverse() * body.get_global_transform()
	#return pos3

func trans_body(to: PhysicsBody, from: PhysicsBody) -> void:
	to.transform = from.transform
	from.replace_by(to)
	from.queue_free()

func rigid_to_kinem(rigid: RigidBody) -> KinematicBody:
	var kinem := KinematicBody.new()
	trans_body(kinem, rigid)
	return kinem

func kinem_to_rigid(kinem: KinematicBody) -> RigidBody:
	var rigid := RigidBody.new()
	trans_body(rigid, kinem)
	return rigid

func rigid_to_stat(rigid: RigidBody) -> StaticBody:
	var stat := StaticBody.new()
	trans_body(stat, rigid)
	return stat

func stat_to_rigid(stat: StaticBody) -> RigidBody:
	var rigid := RigidBody.new()
	trans_body(rigid, stat)
	return rigid

func kinem_to_stat(kinem: KinematicBody) -> StaticBody:
	var stat := StaticBody.new()
	trans_body(stat, kinem)
	return stat

func stat_to_kinem(stat: StaticBody) -> KinematicBody:
	var kinem := KinematicBody.new()
	trans_body(kinem, stat)
	return kinem


func _on_Area_body_entered(body):
	if temp_look == null && looking_at == null:
		temp_look = body
		$PDA.start(0.3)
	all_looks.append(body)


func _on_Area_body_exited(body):
	if temp_look == body:
		temp_look = null
		$PDA.stop()
	if body == looking_at:
		looking_at = null
		$PDA2/text.bbcode_text = ""
	if all_looks.has(body):
		all_looks.remove(all_looks.find(body))
	if all_looks.size() > 0:
		temp_look = all_looks[0]
		$PDA.start(0.15)


func _on_PDA_timeout():
	looking_at = temp_look
	temp_look = null
	#gets info from components, volts amps resistance, errors etc
	var info
	if looking_at.is_in_group("wirebit"):
		info = looking_at.get_parent().get_info()
	elif looking_at.is_in_group("door"):
		info = looking_at.get_parent().get_parent().get_info()
	else:
		info = looking_at.get_info()
	var text
	if info[0] == "wire" || info[0] == "node":
		print(String(info[2]))
		if info[1] == false:
			text = "[center][color=black]Volts: "+ String(info[2]) +"V \nStroomsterkte: "+ String(info[3]) +"A \nWeerstand: ~ \nError: ~[/color][/center]"
		else:
			text = "[center][color=black]Volts: "+ String(info[2]) +"V \nStroomsterkte: "+ String(info[3]) +"A \nWeerstand: ~ \nError: [/color][u][b][color=red]" + info[5]+"[/color][/b][/u][center]"
	elif info[0] == "appliance":
		if info[1] == false:
			text = "[center][color=black]Volts: "+ String(info[2]) +"V \nStroomsterkte: "+ String(info[3]) +"A \nWeerstand: ~ \nError: ~[/color][/center]"
		else:
			text = "[center][color=black]Volts: "+ String(info[2]) +"V \nStroomsterkte: "+ String(info[3]) +"A \nWeerstand: ~ \nError: [/color][u][b][color=red]" + info[5]+"[/color][/b][/u][/center]"
	elif info[0] == "battery":
		if info[1] == false:
			text = "[center][color=black]Volts: "+ String(info[2]) +"V \nStroomsterkte: "+ String(info[3]) +"A \nWeerstand: ~ \nError: ~[/color][/center]"
		else:
			text = "[center][color=black]Volts: "+ String(info[2]) +"V \nStroomsterkte: "+ String(info[3]) +"A \nWeerstand: ~ \nError: [/color][u][b][color=red]" + info[5]+"[/color][/b][/u][/center]"
	$PDA2/text.bbcode_text = text
