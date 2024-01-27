extends GraphNode
class_name Chip

enum types {CHIP,INPUT,OUTPUT}

var group : String = ""
var type = types.CHIP
var slots : Array[Slot] = []
var input_slots : int = 0
var output_slots : int = 0

@export var id : int = 0 # ignored if type == types.CHIP, else the assigned slot

@export var memory : bool = false

var use_tt : bool = true
@export var tt : Dictionary = {}
var circuit : Circuit

func log_start(fname : String):
	print("%s : %s - start" % [name,fname])

func log_msg(fname : String,msg : String):
	print("%s : %s - %s" % [name,fname,msg])

func log_end(fname : String):
	print("%s : %s - done" % [name,fname])

func _ready():
	log_start("_ready")
	setup()
	log_end("_ready")

func setup():
	log_start("setup")
	if memory == true:
		use_tt = false
	
	input_slots = 0
	output_slots = 0
	for s : Slot in slots:
		if s.input_enabled:
			input_slots += 1
		if s.output_enabled:
			output_slots += 1
	log_end("setup")

func set_input(port : int, state : bool)->bool:
	log_start("set_input")
	log_msg("set_input","arguments - port:%s,state:%s"%[port,state])
	log_msg("set_input","check_port : start")
	if port < slots.size():
		if slots[port].input_enabled:
			slots[port].input_state = state
			log_msg("set_input","check_port : done - true : success")
			log_end("set_input")
			return true
		else:
			log_msg("set_input","check_port : done - false : input disabled")
			log_end("set_input")
			return false
	else:
		log_msg("set_input","check_port : done - false : out of range")
		log_end("set_input")
		return false

func get_input_data()->Array[bool]:
	log_start("get_input_data")
	var r : Array[bool] = []
	log_msg("get_input_data","get_output_values : start")
	for i in slots.size():
		if slots[i].input_enabled:
			r.append(slots[i].input_state)
	log_msg("get_input_data","get_output_values : done - %s"%r)
	log_end("get_input_data")
	return r

func simulate()->void:
	log_start("simulate")
	if not use_tt:
		log_msg("simulate","simulate_circuit : start")
		circuit.simulate()
		log_msg("simulate","simulate_circuit : done")
	log_end("simulate")

func get_output(port : int = 0)->bool:
	log_start("get_output")
	log_msg("get_output","arguments - port:%s"%port)
	log_msg("get_output","check_type : start")
	if type == types.CHIP:
		log_msg("get_output","check_truth_table : start")
		if use_tt:
			log_msg("get_output","check_truth_table : done - true : use_tt == true")
			log_msg("get_output","check_type : done - %s : type == chip"%get_tt_output(port))
			log_end("get_output")
			return get_tt_output(port)
		else:
			log_msg("get_output","check_truth_table : done - false : use_tt == false")
			log_msg("get_output","check_type : done - %s : type == chip"%bool(circuit.output_data[port]) if port < circuit.output_data.size() else false)
			log_end("get_output")
			return circuit.output_data[port] if port < circuit.output_data.size() else false
	elif type == types.INPUT:
		log_msg("get_output","check_type : done - %s : type == input"%slots[port].output_state)
		log_end("get_output")
		return slots[port].output_state
	elif type == types.OUTPUT:
		log_msg("get_output","check_type : done - false : type == output")
		log_end("get_output")
		return false
	else:
		log_msg("get_output","check_type : done - false : invalid type")
		log_end("get_output")
		return false

func get_tt_output(port : int)->bool:
	log_start("get_tt_output")
	log_msg("get_tt_output","arguments - port:%s"%port)
	log_msg("get_tt_output","encode_inputs : start")
	var input = encode_bits(get_input_data())
	log_msg("get_tt_output","encode_inputs : done")
	log_msg("get_tt_output","get_decode_output : start")
	var out = decode_bits(tt.get(input),true)
	log_msg("get_tt_output","get_decode_output : done")
	if out == null:
		log_msg("get_tt_output","result - null : unknown error")
		log_end("get_tt_output")
		return false
	log_msg("get_tt_output","result - %s : tt value"%out[port])
	log_end("get_tt_output")
	return out[port]

func encode_bits(data : Array[bool]):
	log_start("encode_bits")
	log_msg("encode_bits","arguments - data:%s"%data)
	var num_string = ""
	for d in data:
		num_string += "1" if d == true else "0"
	var num = int(num_string)
	log_msg("encode_bits","result - 0b%s : encoded bits"%num_string)
	log_end("encode_bits")
	return 0b + num

func decode_bits(bits : int, output : bool):
	log_start("decode_bits")
	log_msg("decode_bits","arguments - bits:%s,output:%s"%[bits,output])
	var times = input_slots
	if output:
		times = output_slots
	var r : Array[bool] = []
	var a := 0
	log_msg("decode_bits","decode_bit : start")
	while a != times:
		r.append(decode_bit(bits,a))
		a += 1
	log_msg("decode_bits","decode_bit : done")
	log_msg("decode_bits","result - %s : decoded bits"%r)
	log_end("decode_bits")
	return r

func decode_bit(bits : int, index : int):
	log_start("decode_bit")
	log_msg("decode_bit","arguments - bits:%s,index:%s"%[bits,index])
	log_msg("decode_bit","result - %s : decoded bit"%decode_bit)
	log_end("decode_bit")
	return ((bits >> index) % 2) == 1
