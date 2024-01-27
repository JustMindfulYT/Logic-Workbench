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
	print("Workspace -- ready")
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)

func _on_menu_button_activated(id : int):
	print("on_menu_button_activated(id : %s)" % str(id))
	match id:
		1:
			$Root/SimulationPopup.visible = !$Root/SimulationPopup.visible
		7:
			print("on_menu_button_activated - load_scene('res://scenes/Main.tscn')")
			Global.load_scene("res://scenes/Main.tscn")



func _on_group_button_activated(_idx):
	pass # Replace with function body.


func _on_workspace_connection_request(from_node, from_port, to_node, to_port):
	print("on_workspace_connection_request(from_node:%s,from_port:%s,to_node:%s,to_port:%s)"%[from_node,from_port,to_node,to_port])
	var connections = $Root/Workspace.get_connection_list()
	print("on_workspace_connection_request - check_connections : start")
	for connection in connections:
		print("on_workspace_connection_request - connection : %s" % connection)
		# from_port, from_node, to_port, to_node
		if connection["to_node"] == to_node:
			print("on_workspace_connection_request - to_node is the same")
			if connection["to_port"] == to_port:
				print("on_workspace_connection_request - to_port is the same")
				return
		print("on_workspace_connection_request - connection : done")
	print("on_workspace_connection_request - check:connections : done")
	print("on_workspace_connection_request - connect_node : start")
	$Root/Workspace.connect_node(from_node,from_port,to_node,to_port)
	print("on_workspace_connection_request - connect_node : done")
	print("on_workspace_connection_request - done")


func _on_workspace_disconnection_request(from_node, from_port, to_node, to_port):
	print("_on_workspace_disconnection_request(from_node:%s,from_port:%s,to_node:%s,to_port:%s)"%[from_node,from_port,to_node,to_port])
	print("_on_workspace_disconnection_request - disconnect_node : start")
	$Root/Workspace.disconnect_node(from_node,from_port,to_node,to_port)
	print("_on_workspace_disconnection_request - disconnect_node : done")
	print("_on_workspace_disconnection_request - done")


func _on_workspace_delete_nodes_request(nodes):
	print("_on_workspace_delete_nodes_request(nodes:%s)"%nodes)
	var connections = $Root/Workspace.get_connection_list()
	print("_on_workspace_delete_nodes_request - disconnect nodes : start")
	for node in nodes:
		print("_on_workspace_delete_nodes_request - node : %s" % node)
		for connection in connections:
			print("_on_workspace_delete_nodes_request - node : conncetion : %s"%connection)
			if connection["from_node"] == node:
				print("_on_workspace_delete_nodes_request - node : disconnect output")
				disconnect_connection(connection)
			if connection["to_node"] == node:
				print("_on_workspace_delete_nodes_request - node : disconnect input")
				disconnect_connection(connection)
			print("_on_workspace_delete_nodes_request - node : connection : done")
		print("_on_workspace_delete_nodes_request - node : done")
		var child = Global.search_array($Root/Workspace.get_children(),node)
		child.queue_free()

func disconnect_connection(c : Dictionary):
	print("disconnect_connection(c:%s)"%c)
	print("disconnect_connection - disconnect_node : start")
	$Root/Workspace.disconnect_node(c["from_node"],c["from_port"],c["to_node"],c["to_port"])
	print("disconnect_connection - disconnect_node : done")
	print("disconnect_connection - done")


func _on_simulate_check_button_toggled(s : bool):
	print("_on_simulate_check_button_toggled(s:%s)"%s)
	allow_simulate = s
	$Root/SimulationPopup/Container/StepButton.disabled = s
	print("_on_simulate_check_button_toggled - done")

func _on_speed_slider_activated(v):
	print("_on_speed_slider_activated(v:%s)"%v)
	$SimulateDelayTimer.wait_time = simulate_speeds.get(v,1)
	print("_on_speed_slider_activated - done")

func _on_step_button_button_down():
	print("_on_step_button_button_down()")
	simulate()
	print("_on_step_button_button_down - done")


func _on_simulate_delay_timer_timeout():
	if allow_simulate:
		simulate()


func simulate():
	print("simulate()")
	# check if a circuit exists
	if circuit:
		print("simulate - circuit : exists")
		# Compare if circuit changed - no? skip, yes? recreate circuit with new chips
		print("simulate - circuit : childs : check")
		if childs != $Root/Workspace.get_children():
			print("simulate - circuit : childs : changed")
			childs = $Root/Workspace.get_children()
			var chips : Array[Chip] = []
			for child in childs:
				if child is Chip:
					chips.append(child)
			print("simulate - circuit : new")
			circuit = Circuit.new($Root/Workspace.get_connection_list(),chips)
			print("simulate - circuit : done")
	else:
		print("simulate - circuit : not found")
		childs = $Root/Workspace.get_children()
		var chips : Array[Chip] = []
		for child in childs:
			if child is Chip:
				chips.append(child)
		print("simulate - circuit : new")
		circuit = Circuit.new($Root/Workspace.get_connection_list(),chips)
		print("simulate - circuit : done")
		
		print("simulate - group : start")
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
		print("simulate - group : done")
		print("simulate - sort : start")
		# sort inputs / outputs
		inputs.sort_custom(sort_chip_id)
		outputs.sort_custom(sort_chip_id)
		print("simulate - sort : done")
		print("simulate - set_inputs : start")
		# set the inputs
		var input_values : Array[bool] = []
		for i in inputs.size():
			input_values.append(inputs[i].get_state())
		circuit.set_inputs(input_values)
		print("simulate - set_inputs : done")
		
		print("simulate - simulate_circuit : start")
		# Simulate the Circuit
		circuit.simulate()
		print("simulate - simulate_circuit : done")
		
		# get the output values
		var output_values : Dictionary = circuit.get_outputs()
		print("simulate - output_values : %s"%output_values)
		print("simulate - set_outputs : start")
		# set the outputs
		for output in outputs:
			output.set_state(output_values.get(output.id,false))
		print("simulate - set_outputs : done")
		print("simulate - done")

# input / output sorting function
func sort_chip_id(a,b):
	print("sort_chip_id(a:%s,b:%s)"%[a,b])
	print("sort_chip_id - done")
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
