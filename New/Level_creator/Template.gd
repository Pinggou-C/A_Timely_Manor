extends Spatial


export(int, 0, 100) var Level = 0
export(bool) var load_previous = false
export(int, 0, 100) var area = 0
export(bool) var last_of_area = false
export(bool) var Load_other_levels = false
export(Array) var Load_levels = []

func _ready():
	if last_of_area == false:
		LevelLoader.Load(Level+1)
	if load_previous != true:
		LevelLoader.unLoad(Level-1)

