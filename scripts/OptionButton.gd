extends OptionButton

signal activated(idx : int)

var open : bool = false

func _on_option_button_mouse_entered():
	$HoverIn.play()


func _on_option_button_mouse_exited():
	$HoverOut.play()


func _on_option_button_button_down():
	if open == false:
		open = true
		$Click.play()
	else:
		open = false
		$Release.play()


func _on_option_button_item_selected(index):
	$Release.play()
	open = false
	emit_signal("activated", index)
