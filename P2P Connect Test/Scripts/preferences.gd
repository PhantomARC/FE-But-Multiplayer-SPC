extends Node


#Credit to NAD LABS for basic save file structure: 
#https://www.youtube.com/watch?v=ZyyiBhZw12w
var path = "user://user_pref.dat"
var file = File.new()
var dict_options = {} #player preference data

func _ready():
	if Preferences.is_file_there() and Preferences.valid(): #trigger load file data for options
		dict_options = Preferences.load_val() if Preferences.is_file_there() else {
				"bgm" : linear2db(1),
				"sfx" : linear2db(1),
			}


func is_file_there() -> bool:
	return file.file_exists(path)


func valid() -> bool:
	return true


func save_val(val : Dictionary) -> void:
	file.open(path,File.WRITE)
	file.store_var(val)
	file.close()


func load_val() -> Dictionary:
	var data : Dictionary
	file.open(path,File.READ)
	data = file.get_var()
	file.close()
	return data
