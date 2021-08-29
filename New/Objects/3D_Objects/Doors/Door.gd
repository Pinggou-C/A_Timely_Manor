extends Spatial
var doing = 0
var connected = 0
var power = 0
var state = "closed"
var indiepow = 0
var wassped = 1
var poscon = false
var negcon = false
var flowable = false
var flowing = false

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
	poscon = body
	if negcon != null:
		var pos = poscon.check()
		var neg = negcon.check()
		if pos == true && neg == true:
			flowable == true


func positive_disconnect(body):
	poscon = null
	if flowable == true:
		flowable = false
	if flowing == true:
		flowing = false
		unpowe()

func negative_connect(body):
	negcon =  body
	if poscon != null:
		var pos = poscon.check()
		var neg = negcon.check()
		if pos == true && neg == true:
			flowable == true


func negative_disconnect(body):
	negcon = null
	if flowable == true:
		flowable = false
	if flowing == true:
		flowing = false
		unpowe()
