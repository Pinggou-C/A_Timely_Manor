extends Spatial
var doing = 0
var connected = 0
var power = 0
var state = "closed"
var indiepow = 0
var wassped = 1

func power(type):
	if type == "indie":
		if Global_Variables.Time_Scale == 1:
			powe()
		indiepow +=1
	elif type == "together":
		power += 1
		if power == connected:
			if Global_Variables.Time_Scale == 1:
				powe()

func unpower(type):
	if type == "indie":
		indiepow -= 1
		if (power != connected || power == 0) && indiepow == 0:
			if Global_Variables.Time_Scale == 1:
				unpowe()
	elif type == "together":
		power -=1
		if indiepow == 0:
			if Global_Variables.Time_Scale == 1:
				unpowe()

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


func connects(type):
	if type == "indie":
		pass
	else:
		connected += 1

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

func velocity(nr):
	if nr == 1 || nr == 3:
		if (power != connected && indiepow ==0) && (state == "open" || state == "opening"):
			unpowe()
		if (power == connected || indiepow > 0) && (state == "closed" || state == "closeing"):
			powe()
		if nr == 1 && $AnimationPlayer.playback_speed == 0:
			$AnimationPlayer.playback_speed = wassped
	elif nr == 0:
		wassped = $AnimationPlayer.playback_speed
		$AnimationPlayer.playback_speed = 0
	elif nr == 4 || nr == 2:
		if state == "opening":
			unpowe()
		if state == "closeing":
			powe()
			
 
