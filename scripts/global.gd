extends Node

var extension_settings : String = ".set"
var extension_circuit : String = ".cir"
var extension_dls2 : String = ".dls"

var last_loaded_scene : String = ""

var Projects : Array[String] = []

var Chips : Array[Chip] = []

var scene_to_load : String = "res://scenes/Main.tscn"

class Result:
	var data = null
	var error = OK
	var error_text = ""

func load_scene(p : String):
	scene_to_load = p
	get_tree().change_scene_to_file("res://scenes/launcher.tscn")

func cash_int_to_str(c : int)->String:
	if c < 1000:
		return str(c)
	elif in_range(c,1000,999999):
		@warning_ignore("integer_division")
		return str(c/1000) + "k"
	elif in_range(c,1000000,999999999):
		@warning_ignore("integer_division")
		return str(c/1000000) + "m"
	elif in_range(c,1000000000,999999999999):
		@warning_ignore("integer_division")
		return str(c/1000000000) + "b"
	elif c >= 1000000000000:
		@warning_ignore("integer_division")
		return str(c/1000000000000) + "t"
	else:
		return "error"

func in_range(v : int,a : int, b : int):
	if v >= a and v <= b:
		return true
	else:
		return false

func save_json_file(path : String, data : Dictionary)->void:
	var data_string : String = JSON.stringify(data)
	if FileAccess.file_exists(path):
		var dir = DirAccess.open(path.get_base_dir())
		dir.remove(path)
	var file = FileAccess.open(path,FileAccess.WRITE)
	file.store_string(data_string)
	file.close()
	return

func load_json_file(path : String)->Result:
	var result = Result.new()
	if FileAccess.file_exists(path):
		var file = FileAccess.open(path,FileAccess.READ)
		var raw = file.get_as_text()
		file.close()
		var data = JSON.parse_string(raw)
		if data == null:
			result.error = ERR_PARSE_ERROR
			result.error_text = "Error Parsing Json at path \n%s\n" % path
			return result
		else:
			result.data = data
			return result
	else:
		result.error = ERR_FILE_NOT_FOUND
		result.error_text = "File at path \n%s\n could not be found!" % path
		return result

func search_array(array : Array, what : String):
	for item in array:
		if item.name == what:
			return item
		else:
			continue
	return null
