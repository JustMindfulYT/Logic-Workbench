extends Button

signal activated

@export_category("Button")

@export var button_up_func : bool = true

var hovered : bool = false

@export var change_scene : bool = false
@export var allow_playing : bool = true

@export var min_time : int = 0
@export var max_time : int = 0

var min_reached : bool = true
var max_reached : bool = true

func _ready():
	if min_time != 0:
		$MinTimer.wait_time = min_time
	if max_time != 0:
		$MaxTimer.wait_time = max_time

func _on_mouse_entered():
	if not disabled:
		if allow_playing == true:
			$HoverIn.play()
		hovered = true

func _on_mouse_exited():
	if not disabled:
		if allow_playing == true:
			$HoverOut.play()
		hovered = false

func _on_button_down():
	if min_time != 0:
		min_reached = false
		$MinTimer.start()
	if max_time != 0:
		max_reached = false
		$MaxTimer.start()
	if allow_playing == true:
		$Click.play()

func _on_button_up():
	if hovered == true:
		if min_reached == true and max_reached == true:
			if allow_playing == true:
				if change_scene == true:
					allow_playing = false
				if button_up_func == true:
					$Release.play()
			emit_signal("activated")


func _on_min_timer_timeout():
	min_reached = true


func _on_max_timer_timeout():
	max_reached = true
