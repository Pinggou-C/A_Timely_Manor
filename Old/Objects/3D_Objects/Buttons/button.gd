extends StaticBody

var allon = 0
export(int, 1, 4) var connected = 1

var connecteds = []
var contypes = []

export var connected1: = NodePath()
export(String, "indie", "together") var contype1 = "indie"
export var connected2: = NodePath()
export(String, "indie", "together") var contype2 = "indie"
export var connected3: = NodePath()
export(String, "indie", "together") var contype3 = "indie"
export var connected4: = NodePath()
export(String, "indie", "together") var contype4 = "indie"

var downn = false

func _ready():
	connecteds.append(get_node(connected1))
	contypes.append(contype1)
	if connected > 1:
		connecteds.append(get_node(connected2))
		contypes.append(contype2)
		if connected > 2:
			connecteds.append(get_node(connected3))
			contypes.append(contype3)
			if connected > 3:
				connecteds.append(get_node(connected4))
				contypes.append(contype4)
	for i in connected:
		connecteds[i].connects(contypes[i])

func _on_Area_body_entered(body):
	if body.is_in_group("weighted"):
		if allon == 0:
			if Global_Variables.Time_Scale == 1 || Global_Variables.Time_Scale == -1:
				$AnimationPlayer.play("down")
				for i in connected:
					connecteds[i].power(contypes[i])
			else:
				pass
		allon += 1

func _on_Area_body_exited(body):
	if body.is_in_group("weighted"):
		allon -= 1
		if allon == 0:
			if Global_Variables.Time_Scale == 1 || Global_Variables.Time_Scale == -1:
				$AnimationPlayer.play("up")
			else:
				pass

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "down":
		downn = true
	if anim_name == "up":
		for i in connected:
			connecteds[i].unpower(contypes[i])
		downn = false



func velocity(nr):
	if nr == 1 || nr == 3:
		if downn == false && allon > 0:
			$AnimationPlayer.play("down")
			for i in connected:
					connecteds[i].power(contypes[i])
		if downn == true && allon == 0:
			$AnimationPlayer.play("up")
			

func down():
	$Tween.interpolate_property($Cube.get_surface_material(2), "albedo_color", Color(0, 0, 0), Color(0, 0, 1), 0.3, Tween.TRANS_CIRC, Tween.EASE_IN)
	$Tween.start()
	$Tween.interpolate_property($Cube.get_surface_material(2), "emission_energy", 0.13, 1, 0.3, Tween.TRANS_CIRC, Tween.EASE_IN)
	$Tween.start()
func up():
	$Tween.interpolate_property($Cube.get_surface_material(2), "albedo_color", Color(0, 0, 1), Color(0, 0, 0), 0.5, Tween.TRANS_CIRC, Tween.EASE_IN_OUT)
	$Tween.start()
	$Tween.interpolate_property($Cube.get_surface_material(2), "emission_energy", 1, 0.13, 0.5, Tween.TRANS_CIRC, Tween.EASE_IN_OUT)
	$Tween.start()
