extends Node


#Credit to NAD LABS for basic save file structure: 
#https://www.youtube.com/watch?v=ZyyiBhZw12w
var path = "user://user_pref.dat"
var file = File.new()


func is_file_there() -> bool:
	var b : bool
	if file.file_exists(path):
		b = true
	return b


func save_val(val : int) -> void:
	file.open(path,File.WRITE)
	file.store_var(val)
	file.close()


func load_val() -> int:
	var tmp : int
	file.open(path,File.READ)
	tmp = file.get_var()
	file.close()
	return tmp
