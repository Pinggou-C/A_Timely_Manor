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

var time = "perm"



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
	posconwire = body
	print("poscon")


func positive_disconnect(body):
	posconwire = null
	print("posdiscon")

func negative_connect(body):
	negconwire =  body
	print("negcon")


func negative_disconnect(body):
	negconwire = null
	print("negdiscon")

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


func conn(wire, newnode, frontback, auto = false):
	var posss
	#get closest
	var posarr = []
	if auto != true:
		if frontback == "front":
			posss = wire.rear
		elif frontback == "rear":
			posss = wire.front
	else:
		if frontback == "front":
			posss = wire.front
		elif frontback == "rear":
			posss = wire.rear
	var pos
	var stop = false
	if wire == posconwire:
		return [$pos1.get_global_transform().origin, 0]
	if newnode != null:
		if !poscon == newnode:
			poscon = newnode
		if !negcon == newnode:
			negcon = newnode
