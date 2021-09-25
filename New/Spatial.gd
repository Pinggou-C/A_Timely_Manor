extends Spatial
var onscreen = true
export(Vector3) var baseangle = Vector3(90, 0, 0)
export(float) var returnspeed = 0.25
export(String, "gimp_ball", "under_arm", "over_arm") var standtype

func _ready():
	get_node("notifier").connect("screen_exited", self, "_on_screen_exited")
	get_node("notifier").connect("screen_entered", self, "_on_screen_entered")

func _on_screen_exited():
	onscreen = false
	print('bye')
func _on_screen_entered():
	onscreen = true
	$Tween.interpolate_property($e1, "rotation_degrees", $e1.rotation_degrees, baseangle, returnspeed, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	$Tween.start()
	print('hi')



func _physics_process(delta):
	if onscreen == false:
		var player = get_tree().get_nodes_in_group("player")
		for i in player:
			var pos = i.get_global_transform().origin
			var dif= get_global_transform().origin - pos
			var angle = asin(dif.x / sqrt(pow(dif.x, 2) + pow(dif.z, 2)))
			var angle2 = asin(dif.y / sqrt(pow(dif.z, 2) + pow(dif.y, 2)))
			var angle3 = asin(dif.y / sqrt(pow(dif.x, 2) + pow(dif.y, 2)))
			if dif.z < 0 :
				angle *= -1
				#angle2 *= -1
			if abs(dif.x) > abs(dif.z):
				angle2 = angle3
			if dif.z > 0:
				angle2*= -1
				
			$e1.rotation_degrees.y = rad2deg(angle)
			$e1.rotation_degrees.x = rad2deg(angle2)+ 90


