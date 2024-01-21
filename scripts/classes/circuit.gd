extends Node

class_name Circuit

var connections : Array[Dictionary] = []
var chips : Array[Chip]
var input_chips : Array[Chip]
var output_chips : Array[Chip]
var output_data : Array[bool]

func _init(c : Array[Dictionary],b : Array[Chip])->void:
	connections = c
	chips = b
	setup()

func copy()->Circuit:
	return Circuit.new(connections,chips)

func _ready():
	setup()

func setup()->void:
	for chip in chips:
		match chip.type:
			Chip.types.INPUT:
				input_chips.append(chip)
			Chip.types.OUTPUT:
				output_chips.append(chip)
			Chip.types.CHIP:
				continue

func simulate()->void:
	## Update Connections
	for connection in connections:
		# from_port, from_node, to_port, to_node
		var from = Global.search_array(chips, connection.get("from_node"))
		if from == null:
			continue
		var to = Global.search_array(chips, connection.get("to_node"))
		if to == null:
			continue
		var state = from.get_output(connection.get("from_port"))
		var err : bool = to.set_input(connection.get("to_port"),state)
		if err == false:
			continue
		else:
			continue
	
	## Simulate Chips
	for chip in chips:
		chip.simulate()

func set_inputs(d : Array[bool])->bool:
	if d.size() != input_chips.size():
		return false
	else:
		for i in input_chips.size():
			input_chips[i].set_state(d[i])
		return true

func get_outputs()->Dictionary:
	var r = []
	for chip in chips:
		if chip.type == Chip.types.OUTPUT:
			r.append([chip.id,chip.slots[0].input_state])
	r.sort_custom(func(a, b): return a[0] > b[0])
	var o : Dictionary = {}
	for result in r:
		o[str(result[0])] = result[1]
	return o
