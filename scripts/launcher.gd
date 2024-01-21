extends Control

var path = Global.scene_to_load

var should_load : bool = false

func _ready():
	if ResourceLoader.exists(path):
		ResourceLoader.load_threaded_request(path)
		should_load = true
	else:
		error("File does not exist")

func _process(_d):
	if should_load:
		var tls = update_label()
		if tls == 0:
			error("Invalid Resource")
		elif tls == 1:
			return
		elif tls == 2:
			error("Internal Error")
		elif tls == 3:
			should_load = false
			Global.last_loaded_scene = path
			var ps = ResourceLoader.load_threaded_get(path)
			get_tree().change_scene_to_packed(ps)
		else:
			error()

func error(r : String = "unknown"):
	$Progress.hide()
	$ErrorDialog.dialog_text  = "A fatal error has Occured\n\n"
	$ErrorDialog.dialog_text += "Failed to load Scene at path : \n' %s '\n" % path
	$ErrorDialog.dialog_text += "Reason : %s" % r
	$ErrorDialog.popup()

func update_label():
	var p : Array = []
	var tls = ResourceLoader.load_threaded_get_status(path, p)
	$Progress.value = p[0]
	return tls


func _on_error_dialog_confirmed():
	Global.load_scene(Global.last_loaded_scene)
