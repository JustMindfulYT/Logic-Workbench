extends MenuButton

signal activated(id : int)

var open : bool = false

func _ready():
	get_popup().id_pressed.connect(_on_menu_button_popup_id_selected)

func _on_menu_button_mouse_entered():
	$HoverIn.play()


func _on_menu_button_mouse_exited():
	$HoverOut.play()


func _on_menu_button_button_down():
	if open == false:
		open = true
		$Click.play()
	else:
		open = false
		$Release.play()


func _on_menu_button_popup_id_selected(id):
	$Release.play()
	open = false
	emit_signal("activated", id)
