extends Control
class_name Slot

@export_category("Slot")
@export var id : int = -1
@export var input_enabled : bool = false
@export var input_state : bool = false
@export var output_enabled : bool = false
@export var output_state : bool = false


func get_pin_state(output : bool):
	if output and output_enabled:
		return output_state
	elif not output and input_enabled:
		return input_state
	else:
		return null

func set_pin_state(state : bool,output : bool):
	if output:
		output_state = state
	else:
		input_state = state
