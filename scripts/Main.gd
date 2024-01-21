extends Control


func _on_play_button_activated():
	$ButtonHolder/PlayButton.visible = false
	$ButtonHolder/SettingsButton.visible = false
	$ButtonHolder/TutorialButton.visible = false
	$ButtonHolder/CreditsButton.visible = false
	$ButtonHolder/QuitButton.visible = false
	
	$ButtonHolder/ContinueButton.visible = true
	$ButtonHolder/LoadButton.visible = true
	$ButtonHolder/NewButton.visible = true
	$ButtonHolder/CancelButton.visible = true


func _on_cancel_button_activated():
	$ButtonHolder/PlayButton.visible = true
	$ButtonHolder/SettingsButton.visible = true
	$ButtonHolder/TutorialButton.visible = true
	$ButtonHolder/CreditsButton.visible = true
	$ButtonHolder/QuitButton.visible = true
	
	$ButtonHolder/ContinueButton.visible = false
	$ButtonHolder/LoadButton.visible = false
	$ButtonHolder/NewButton.visible = false
	$ButtonHolder/CancelButton.visible = false


func _on_quit_button_activated():
	$ButtonHolder/PlayButton.visible = false
	$ButtonHolder/SettingsButton.visible = false
	$ButtonHolder/TutorialButton.visible = false
	$ButtonHolder/CreditsButton.visible = false
	$ButtonHolder/QuitButton.visible = false
	
	$ButtonHolder/CancelQuitButton.visible = true
	$ButtonHolder/ConfirmQuitButton.visible = true


func _on_cancel_quit_button_activated():
	$ButtonHolder/PlayButton.visible = true
	$ButtonHolder/SettingsButton.visible = true
	$ButtonHolder/TutorialButton.visible = true
	$ButtonHolder/CreditsButton.visible = true
	$ButtonHolder/QuitButton.visible = true
	
	$ButtonHolder/CancelQuitButton.visible = false
	$ButtonHolder/ConfirmQuitButton.visible = false

func _ready():
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func _on_confirm_quit_button_activated():
	get_tree().quit()

func _on_new_button_activated():
	Global.load_scene("res://scenes/NewProject.tscn")

func _on_settings_button_activated():
	Global.load_scene("res://scenes/Settings.tscn")

func _on_tutorial_button_activated():
	Global.load_scene("res://scenes/Turtorial.tscn")

func _on_credits_button_activated():
	Global.load_scene("res://scenes/Credits.tscn")
