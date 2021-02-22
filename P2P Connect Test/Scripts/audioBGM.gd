extends AudioStreamPlayer


func _ready():
	
	pause_mode = Node.PAUSE_MODE_PROCESS
	change_vol()
	add_to_group("bgm_vol")
	playing = true

func change_vol():
	volume_db = Preferences.dict_options["bgm"]
