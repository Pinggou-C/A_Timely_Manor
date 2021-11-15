extends Spatial
var doing = 0
var connected = 0
var power = 0
var state = "closed"
var indiepow = 0
var wassped = 1
var poscon = null
var negcon = null
var posconwire = null
var negconwire = null
var flowable = false
var flowing = false
var posconbattery = false
var negconbattery = false
var time = "perm"

var closed = false
var closed_connecteds = []
var connected_to_battery = "not"

var amps = 0
var volts = 0
var resistance

export(int,1, 100) var volt_needs = 1
export(int,1, 1000) var watt_needs = 1

var error = null

func _on_AnimationPlayer_animation_finished(_anim_name):
	if doing == 2:
		$Tween.interpolate_property($Cube002.get_surface_material(1), "albedo_color", Color(0, 0, 1), Color(0, 0, 0), 0.3, Tween.TRANS_CIRC, Tween.EASE_IN)
		$Tween.start()
		$Tween.interpolate_property($Cube002.get_surface_material(1), "emission_energy", 0.6, 0.13, 0.5, Tween.TRANS_CIRC, Tween.EASE_IN_OUT)
		$Tween.start()
		state = "closed"
	elif doing == 1:
		state = "open"
	doing = 0

func powe():
	if state == "closed" || state == "closeing":
		if doing == 2:
			if $AnimationPlayer.playback_speed == -1:
				$AnimationPlayer.playback_speed = 1
			else:
				$AnimationPlayer.playback_speed = -1
		elif doing == 0:
			$AnimationPlayer.playback_speed = 1
			$AnimationPlayer.play("default")
		doing = 1
		$Tween.interpolate_property($Cube002.get_surface_material(1), "albedo_color", Color(0, 0, 0), Color(0, 0, 1), 0.3, Tween.TRANS_CIRC, Tween.EASE_IN)
		$Tween.start()
		$Tween.interpolate_property($Cube002.get_surface_material(1), "emission_energy", 0.13, 0.6, 0.3, Tween.TRANS_CIRC, Tween.EASE_IN_OUT)
		$Tween.start()
		
		state = "opening"

func unpowe():
	if state == "open" || state == "opening":
		if doing == 1:
			if $AnimationPlayer.playback_speed == -1:
				$AnimationPlayer.playback_speed = 1
			else:
				$AnimationPlayer.playback_speed = -1
		elif doing == 0:
			$AnimationPlayer.playback_speed = 1
			$AnimationPlayer.play_backwards("default")
		doing = 2
		state = "closeing"


func positive_connect(body):
	posconwire = body.get_parent()
	print("poscon")


func positive_disconnect(body):
	if posconwire == body.get_parent():
		posconwire = null
		print("posdiscon")

func negative_connect(body):
	negconwire =  body.get_parent()
	print("negcon")
	print(body)


func negative_disconnect(body):
	if negconwire == body.get_parent():
		negconwire = null
		print("posdiscon")

func get_info():
	if error == null:
		return(["appliance", false, volts, amps, 0, error, flowing, volt_needs, watt_needs])
	else:
		return(["appliance", true, volts, amps, 0, error, flowing, volt_needs, watt_needs])

func conecteds():
	if negcon != null && poscon != null:
		return [self, [poscon, negcon], "appliance", 1]
	else:
		return [0, 0, "error"]


func conn(wire, newnode, frontback, auto = false, voltamp = []):
	var posss
	print("hi")
	#get closest
	var posarr = []
	var pos
	var stop = false
	if frontback == "front":
		posconwire = wire
		return [$pos1.get_global_transform().origin, 0]
	elif frontback == "rear":
		negconwire = wire
		return [$pos2.get_global_transform().origin, 1]
	if newnode != null:
		if !poscon == newnode && frontback == "front":
			poscon = newnode
			if negcon != null:
				closed = true
				negcon.con_close(true, self)
				poscon.con_close(true, self)
				if closed_connecteds.size() > 1:
					if ElectricsUpdate.battery_closed == true:
						ElectricsUpdate.closed_batteries(0).start_connecting()
		if !negcon == newnode && frontback == "rear":
			negcon = newnode
			if poscon != null:
				closed = true
				negcon.con_close(true, self)
				poscon.con_close(true, self)
				if closed_connecteds.size() > 1:
					if ElectricsUpdate.battery_closed == true:
						ElectricsUpdate.closed_batteries(0).start_connecting()

func disconnect_wire(wire):
	if wire == posconwire:
		posconwire = null
		if poscon != null:
			poscon = null
			posconbattery = false
	elif wire == negconwire:
		negconwire = null
		if negcon != null:
			negcon = null
			negconbattery = false

func disconnect_node(node):
	if node == poscon:
		closed = false
		if negcon != null:
			negcon.con_close(false, self)
		if poscon != null:
			poscon.con_close(false, self)
		posconbattery = false
		poscon = null
	elif node == negcon:
		closed = false
		if negcon != null:
			negcon.con_close(false, self)
		if poscon != null:
			poscon.con_close(false, self)
		negcon = null
		negconbattery = false

func con_node(node, wire, is_battery = null):
	if wire == posconwire:
		poscon = node
		if is_battery == true:
			posconbattery = true
		if negcon != null:
			closed = true
			negcon.con_close(true, self)
			poscon.con_close(true, self)
			if closed_connecteds.size() > 1:
				if ElectricsUpdate.battery_closed == true:
					ElectricsUpdate.closed_batteries(0).start_connecting()
	elif wire == negconwire:
		negcon = node
		if is_battery == true:
			negconbattery = true
		if poscon != null:
			closed = true
			negcon.con_close(true, self)
			poscon.con_close(true, self)
			if closed_connecteds.size() > 1:
				if ElectricsUpdate.battery_closed == true:
					ElectricsUpdate.closed_batteries(0).start_connecting()

func con_close(truefalse, node):
	if truefalse == true:
		closed_connecteds.append(node)
	else:
		closed_connecteds.erase(node)
