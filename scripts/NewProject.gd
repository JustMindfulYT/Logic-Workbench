extends Control

@export var starter_cash_values : Array[int] = [100,200,500,1000,2000,5000,10000,50000,100000,500000,1000000]

func _on_starter_cash_value_changed(value):
	$Data/Labels/StarterCash.text = "Cash ( %s )" % Global.cash_int_to_str(starter_cash_values[value])

func _process(_delta):
	$CreateButton.disabled = check_disabled()
	

func _on_name_text_changed(new_text):
	if new_text != "":
		$Title.text = new_text
	else:
		$Title.text = "Unnamed Project"


func _on_cancel_button_activated():
	Global.load_scene("res://scenes/Main.tscn")


func _on_create_button_activated():
	Global.load_scene("res://scenes/Workspace.tscn")

func check_disabled():
#	0 = Good, 1 = Middle, 2 = Bad
	var s : Array[int] = [0,0,0,0]
	if $Data/Inputs/Name.text.is_empty():
		$Hint/NameEmpty.show()
		s[0] = 2
	else:
		$Hint/NameEmpty.hide()
	if $Data/Inputs/Name.text in Global.Projects:
		$Hint/NameDuplicate.show()
		s[1] = 2
	else:
		$Hint/NameDuplicate.hide()
	if $Data/Inputs/OptionButton.selected == -1:
		$Hint/ModeEmpty.show()
		s[2] = 2
	else:
		$Hint/ModeEmpty.hide()
	if $Data/Inputs/StarterCash.value < 3 and s.max() == 0:
		$Hint/CashLow.show()
		s[3] = 1
	else:
		$Hint/CashLow.hide()
	if s.max() == 0:
		$Hint/AllGood.show()
		return false
	elif s.max() == 1:
		$Hint/AllGood.hide()
		return false
	elif s.max() == 2:
		$Hint/AllGood.hide()
		return true
