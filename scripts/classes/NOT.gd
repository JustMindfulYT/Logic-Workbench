extends Chip

func _ready():
	slots.append($Slot)
	tt = {
		0b0:0b1,
		0b1:0b0
	}
	use_tt = true
	setup()
