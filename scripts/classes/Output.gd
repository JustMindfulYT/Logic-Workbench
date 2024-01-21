extends Chip

func _ready():
	type = types.INPUT
	slots.append($Slot)
	setup()

func _on_id_value_changed(v : float):
	@warning_ignore("narrowing_conversion")
	id = v

func set_state(s : bool):
	$State.button_pressed = s
	$Slot.set_pin_state(s,true)

func get_state():
	return $Slot.get_pin_state(true)
