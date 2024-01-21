extends CheckBox

signal activated(state : bool)

var hovered : bool = false

func _on_mouse_entered():
	if not disabled:
		$HoverIn.play()
		hovered = true

func _on_mouse_exited():
	if not disabled:
		$HoverOut.play()
		hovered = false

func _on_button_down():
	$Click.play()

func _on_toggled(s : bool):
	if hovered == true:
		$Release.play()
	emit_signal("activated",s)


func _on_button_up():
	pass
