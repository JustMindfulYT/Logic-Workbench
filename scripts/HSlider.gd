extends HSlider

signal activated(v : int)


func _on_mouse_entered():
	if editable:
		$HoverIn.play()

func _on_mouse_exited():
	if editable:
		$HoverOut.play()

func _on_drag_started():
	$Click.play()

func _on_drag_ended(_v):
	$Release.play()
	emit_signal("activated", value)
