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
	log_start("_ready")
	setup()
	log_end("_ready")

func log_start(fname : String):
	print("%s : %s - start" % [name,fname])

func log_msg(fname : String,msg : String):
	print("%s : %s - %s" % [name,fname,msg])

func log_end(fname : String):
	print("%s : %s - done" % [name,fname])

func setup()->void:
	log_start("setup")
	for chip in chips:
		match chip.type:
			Chip.types.INPUT:
				input_chips.append(chip)
			Chip.types.OUTPUT:
				output_chips.append(chip)
			Chip.types.CHIP:
				continue
	log_end("setup")

func simulate()->void:
	log_start("simulate")
	log_msg("simulate","update_connections : start")
	## Update Connections
	for connection in connections:
		log_msg("simulate","update_connections : connection : %s"%connection)
		# from_port, from_node, to_port, to_node
		var from = Global.search_array(chips, connection.get("from_node"))
		if from == null:
			log_msg("simulate","update_connections : continue - from_node == null")
			continue
		var to = Global.search_array(chips, connection.get("to_node"))
		if to == null:
			log_msg("simulate","update_connections : continue - to_node == null")
			continue
		var state = from.get_output(connection.get("from_port"))
		var err : bool = to.set_input(connection.get("to_port"),state)
		if err == false:
			log_msg("simulate","update_connections : continue - to_port : error == false")
			continue
		else:
			log_msg("simulate","update_connections : continue - to_port : error == true")
			continue
	log_msg("simulate","update_connections : end")
	
	log_msg("simulate","simulate_chips : start")
	## Simulate Chips
	for chip in chips:
		chip.simulate()
	log_msg("simulate","simulate_chips : end")
	log_end("simulate")

func set_inputs(d : Array[bool])->bool:
	log_start("set_inputs")
	log_msg("set_inputs","check_array_size : start")
	if d.size() != input_chips.size():
		log_msg("set_inputs","check_array_size : done - does not match")
		log_end("set_inputs")
		return false
	else:
		log_msg("set_inputs","check_array_size : done - does match")
		log_msg("set_inputs","set_values : start")
		for i in input_chips.size():
			log_msg("set_inputs","set_values : i=%s,node=%s,value=%s"%[i,input_chips[i],d[i]])
			input_chips[i].set_state(d[i])
		log_msg("set_inputs","set_values : done")
		log_end("set_inputs")
		return true

func get_outputs()->Dictionary:
	log_start("get_outputs")
	var r = []
	log_msg("get_outputs","group_chips : start")
	for chip in chips:
		if chip.type == Chip.types.OUTPUT:
			r.append([chip.id,chip.slots[0].input_state])
	log_msg("get_outputs","group_chips : done")
	log_msg("get_outputs","sort_chips : start")
	r.sort_custom(func(a, b): return a[0] > b[0])
	log_msg("get_outputs","sort_chips : done - %s"%str(r))
	var o : Dictionary = {}
	log_msg("get_outputs","make_result : start")
	for result in r:
		o[str(result[0])] = result[1]
	log_msg("get_outputs","make_result : done - %s"%o)
	log_end("get_outputs")
	return o
