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

func _ready():
	setup()

func setup():
	if memory == true:
		use_tt = false
	
	input_slots = 0
	output_slots = 0
	for s : Slot in slots:
		if s.input_enabled:
			input_slots += 1
		if s.output_enabled:
			output_slots += 1

func set_input(port : int, state : bool)->bool:
	if port < slots.size():
		if slots[port].input_enabled:
			slots[port].input_state = state
			return true
		else:
			return false
	else:
		return false

func get_input_data()->Array[bool]:
	var r : Array[bool] = []
	for i in slots.size():
		if slots[i].input_enabled:
			r.append(slots[i].input_state)
	return r

func simulate()->void:
	if not use_tt:
		circuit.simulate()

func get_output(port : int = 0)->bool:
	if type == types.CHIP:
		if use_tt:
			return get_tt_output(port)
		else:
			return circuit.output_data[port] if port < circuit.output_data.size() else false
	elif type == types.INPUT:
		return slots[port].output_state
	else:
		return false

func get_tt_output(port : int)->bool:
	var input = encode_bits(get_input_data())
	var out = decode_bits(tt.get(input),true)
	if out == null:
		return false
	return out[port]

func encode_bits(data : Array[bool]):
	var num_string = ""
	for d in data:
		num_string += d
	var num = int(num_string)
	return 0b + num

func decode_bits(bits : int, output : bool):
	var times = input_slots
	if output:
		times = output_slots
	var r : Array[bool] = []
	var a := 0
	while a != times:
		r.append(decode_bit(bits,a))
		a += 1
	return r

func decode_bit(bits : int, index : int):
	return ((bits >> index) % 2) == 1
