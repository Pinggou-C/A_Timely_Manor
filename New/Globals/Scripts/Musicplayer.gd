extends Control


var current_music = "splash"
var playing = false
var action = "idle"
#a dictionary containing all songs, allong, with the nodes they are assigned to and what their up and down volumes are [the node, dup volume, down volume]
var musics = {"splash":[3, -5, 20]}

func _ready():
	pass

func fadeout(time):
	action = "fadeout"
	$fadeout.interpolate_property(get_node(musics[current_music][0]), "volume_db", musics[current_music][1], musics[current_music][2], time,Tween.TRANS_LINEAR)

func fadein(time):
	$fadein.interpolate_property(get_node(musics[current_music][0]), "volume_db", musics[current_music][2], musics[current_music][1], time,Tween.TRANS_LINEAR)

func new_music(new_song, tweentime):
	if tweentime == 0:
		pass
	else:
		pass
