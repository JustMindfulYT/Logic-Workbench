extends PanelContainer

var chip_groups : Dictionary = {}

var chip_input = preload("res://scenes/classes/Input.tscn")
var chip_output = preload("res://scenes/classes/Output.tscn")
var chip_and = preload("res://scenes/classes/AND.tscn")
var chip_nand = preload("res://scenes/classes/NAND.tscn")
var chip_not = preload("res://scenes/classes/NOT.tscn")

var circuit : Circuit
var childs : Array[Node]

@export var simulate_speeds : Dictionary = {0: 0.01,1:0.05,2:0.1,3:0.2,4:0.5,5:1}
var allow_simulate : bool = false

func _ready():
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)

func _on_menu_button_activated(id : int):
	match id:
		1:
			$Root/SimulationPopup.visible = !$Root/SimulationPopup.visible
		7:
			Global.load_scene("res://scenes/Main.tscn")



func _on_group_button_activated(_idx):
	pass # Replace with function body.


func _on_workspace_connection_request(from_node, from_port, to_node, to_port):
	var connections = $Root/Workspace.get_connection_list()
	for connection in connections:
		print(connection)
		# from_port, from_node, to_port, to_node
		if connection["to_node"] == to_node:
			if connection["to_port"] == to_port:
				return
	$Root/Workspace.connect_node(from_node,from_port,to_node,to_port)


func _on_workspace_disconnection_request(from_node, from_port, to_node, to_port):
	$Root/Workspace.disconnect_node(from_node,from_port,to_node,to_port)


func _on_workspace_delete_nodes_request(nodes):
	var connections = $Root/Workspace.get_connection_list()
	for node in nodes:
		for connection in connections:
			if connection["from_node"] == node:
				disconnect_connection(connection)
			if connection["to_node"] == node:
				disconnect_connection(connection)
		var child = Global.search_array($Root/Workspace.get_children(),node)
		child.queue_free()

func disconnect_connection(c : Dictionary):
	$Root/Workspace.disconnect_node(c["from_node"],c["from_port"],c["to_node"],c["to_port"])


func _on_simulate_check_button_toggled(s : bool):
	allow_simulate = s
	$Root/SimulationPopup/Container/StepButton.disabled = s

func _on_speed_slider_activated(v):
	$SimulateDelayTimer.wait_time = simulate_speeds.get(v,1)

func _on_step_button_button_down():
	simulate()


func _on_simulate_delay_timer_timeout():
	if allow_simulate:
		simulate()


func simulate():
	# check if a circuit exists
	if circuit:
		# Compare if circuit changed - no? skip, yes? recreate circuit with new chips
		if childs != $Root/Workspace.get_children():
			childs = $Root/Workspace.get_Children()
			var chips : Array[Chip] = []
			for child in childs:
				if child is Chip:
					chips.append(child)
			circuit = Circuit.new($Root/Workspace.get_connection_list(),chips)
		
		# group inputs / outputs
		var inputs : Array[Chip] = []
		var outputs : Array[Chip] = []
		for child in childs:
			if child is Chip:
				match child.type:
					Chip.types.INPUT:
						inputs.append(child)
						continue
					Chip.types.OUTPUT:
						outputs.append(child)
						continue
					_:
						continue
		# sort inputs / outputs
		inputs.sort_custom(sort_chip_id)
		outputs.sort_custom(sort_chip_id)
		# set the inputs
		var input_values : Array[bool] = []
		for i in inputs.size():
			input_values.append(inputs[i].get_state())
		circuit.set_inputs(input_values)
		
		# Simulate the Circuit
		circuit.simulate()
		
		# get the output values
		var output_values :Dictionary = circuit.get_outputs()
		# set the outputs
		for output in outputs:
			output.set_state(output_values.get(output.id,false))

# input / output sorting function
func sort_chip_id(a,b):
	return a.id > b.id

var simulation_popup_mouse : bool = false

func _on_simulation_popup_close_requested():
	if simulation_popup_mouse == true:
		$Root/SimulationPopup.hide()


func _on_simulation_popup_mouse_entered():
	simulation_popup_mouse = true


func _on_simulation_popup_mouse_exited():
	simulation_popup_mouse = false


func _on_not_activated():
	var node = chip_not.instantiate()
	$Root/Workspace.add_child(node)


func _on_and_activated():
	var node = chip_and.instantiate()
	$Root/Workspace.add_child(node)


func _on_nand_activated():
	var node = chip_nand.instantiate()
	$Root/Workspace.add_child(node)


func _on_input_activated():
	var node = chip_input.instantiate()
	$Root/Workspace.add_child(node)


func _on_output_activated():
	var node = chip_output.instantiate()
	$Root/Workspace.add_child(node)
