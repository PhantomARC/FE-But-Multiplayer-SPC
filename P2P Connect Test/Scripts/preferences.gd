extends Node


#Credit to NAD LABS for basic save file structure: 
#https://www.youtube.com/watch?v=ZyyiBhZw12w
var path = "user://user_pref.dat"
var file = File.new()


func is_file_there() -> bool:
	return file.file_exists(path)


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
