extends Chip

func _ready():
	slots.append($Slot)
	slots.append($Slot_2)
	tt = {
		0b00:0b1,
		0b01:0b1,
		0b10:0b1,
		0b11:0b0
	}
	use_tt = true
	setup()
