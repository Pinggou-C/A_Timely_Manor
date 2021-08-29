extends KinematicBody

var gravity = Vector3.DOWN * 18
var speed  = 6
var jump_speed  = 9
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
	var pos_next = ($Head.get_global_transform() * rel_pos).origin
	var vel = (pos_next - pos_cur) / delta
	pickvel = pick.move_and_slide(vel, Vector3.UP, false, 4, PI/4, false)
func get_input():
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
	velocety.y = vc
	jump = false
	if Input.is_action_just_pressed("jump"):
		jump = true
	if Input.is_action_just_pressed("grab"):
		if picked == false:
			if $RayCast.is_colliding():
				var coll = $RayCast.get_collider()
				pick = coll
				rel_pos = get_rel_pos(pick)
				if pick.is_in_group("weighted"):
					pickgroups.append("weighted")
					pick.get_child(2).pickup()
				var body := rigid_to_kinem(pick)
				pick = body
				picked = true
		elif picked == true:
			var body := kinem_to_rigid(pick)
			body.linear_velocity = pickvel * 0.75
			body.set_collision_layer_bit(19, true)
			body.get_child(2).drop(pickvel * 0.75)
			print(pickvel * 0.75)
			pick = null
			picked = false
			print('hiwa')
			for i in pickgroups:
				body.add_to_group(i)
			


func _input(event):
	if event is InputEventMouseMotion:
		mouseDelta = event.relative
		
		##$Camera.rotation_degrees.z  += event.relative.z

func _process(_delta):
	$Camera.rotation_degrees.x = lerp($Camera.rotation_degrees.x, $Camera.rotation_degrees.x - mouseDelta.y*2, 0.0333)
	$Camera.rotation_degrees.x = clamp($Camera.rotation_degrees.x, -89, 89) 
	rotation_degrees.y = lerp(rotation_degrees.y, rotation_degrees.y - mouseDelta.x*3, 0.0333)
	mouseDelta = Vector2()
	$Head.rotation_degrees.x = lerp($Head.rotation_degrees.x, $Camera.rotation_degrees.x, 0.33)
	$RayCast.rotation_degrees.x = lerp($RayCast.rotation_degrees.x, $Camera.rotation_degrees.x, 0.33)

# Get the `Transform` of a `PhysicsBody` relative to the player position
func get_rel_pos(body):
	return $Head.get_global_transform().inverse() * body.get_global_transform()

func trans_body(to: PhysicsBody, from: PhysicsBody) -> void:
	to.transform = from.transform
	from.replace_by(to)
	from.queue_free()

# Convert a `RigidBody` scene node to `KinematicBody`
func rigid_to_kinem(rigid: RigidBody) -> KinematicBody:
	var kinem := KinematicBody.new()
	trans_body(kinem, rigid)
	return kinem

# Convert a `KinematicBody` scene node to `RigidBody`
func kinem_to_rigid(kinem: KinematicBody) -> RigidBody:
	var rigid := RigidBody.new()
	trans_body(rigid, kinem)
	return rigid
