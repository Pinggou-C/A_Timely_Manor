extends Spatial


var playing = false
var current
export(bool) var start_playing = true
export(bool) var multi_song = true
export(AudioStreamMP3) var music
export(AudioStreamMP3) var music2
export(AudioStreamMP3) var music3
export(AudioStreamMP3) var music4

func _ready():
	var current = 0
	$player.stream = music
	$player.stream_paused = false
	$player.playing = true


func _pause():
	get_node(current).stream_paused = true

func _on_player_finished():
	if multi_song == true:
		if current == 0:
			$player2.stream = music2
			$player2.stream_paused = false
			$player2.playing = true
		elif current == 1:
			$player.stream = music3
			$player.stream_paused = false
			$player.playing = true
		elif current == 2:
			$player2.stream = music4
			$player2.stream_paused = false
			$player2.playing = true
		elif current == 3:
			$player.stream = music
			$player.stream_paused = false
			$player.playing = true
		current += 1
	else:
		$player.stream = music
		$player.stream_paused = false
		$player.playing = true
