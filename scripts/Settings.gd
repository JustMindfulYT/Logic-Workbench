extends Control

@export var settings_path : String = "user://settings.json"

var settings : Dictionary = {
	"audio": {
		"master": {
			"muted" : false,
			"volume" : 0.0
		},
		"ui": {
			"muted" : false,
			"volume" : -1.7
		},
		"ui_sfx": {
			"muted" : false,
			"volume" : -8.0
		}
	}
}

func _on_save_button_activated():
	Global.save_json_file(settings_path,settings)
	Global.load_scene("res://scenes/Main.tscn")

func _on_cancel_button_activated():
	Global.load_scene("res://scenes/Main.tscn")

func convert_volume(v:int)->String:
	var volume = str(v)
	if v > 0:
		volume = "+" + str(v)
	return "Volume : %s db" % volume

func load_settings():
	var file_result = Global.load_json_file(settings_path)
	if file_result.error != OK:
		return
	else:
		var data = file_result.data
		settings.merge(data,true)

func update_settings():
	var audio = settings.get("audio")
	var audio_master = audio.get("master")
	AudioServer.set_bus_volume_db(0,audio_master.get("volume"))
	AudioServer.set_bus_mute(0,audio_master.get("mute"))
	var audio_ui = audio.get("ui")
	AudioServer.set_bus_volume_db(1,audio_ui.get("volume"))
	AudioServer.set_bus_mute(1,audio_ui.get("mute"))
	var audio_ui_sfx = audio.get("ui_sfx")
	AudioServer.set_bus_volume_db(2,audio_ui_sfx.get("volume"))
	AudioServer.set_bus_mute(2,audio_ui_sfx.get("mute"))
	update_audio_ui()

func update_audio_ui():
	$Scroll/Container/Master/HBox/Mute.button_pressed = AudioServer.is_bus_mute(0)
	$Scroll/Container/Master/HBox/VolumeSlider.value = AudioServer.get_bus_volume_db(0)
	
	$Scroll/Container/UI/HBox/Mute.button_pressed = AudioServer.is_bus_mute(1)
	$Scroll/Container/UI/HBox/VolumeSlider.value = AudioServer.get_bus_volume_db(1)
	
	$Scroll/Container/UI_SFX/HBox/Mute.button_pressed = AudioServer.is_bus_mute(2)
	$Scroll/Container/UI_SFX/HBox/VolumeSlider.value = AudioServer.get_bus_volume_db(2)

func _ready():
	load_settings()

func _on_audio_master_mute_activated(state):
	AudioServer.set_bus_mute(0,state)
	settings["audio"]["master"]["mute"] = state
	$Scroll/Container/Master/HBox/VolumeSlider.editable = !state
	if state == true:
		$Scroll/Container/Master/HBox/VolumeLabel.text = "Volume : muted"
	else:
		$Scroll/Container/Master/HBox/VolumeLabel.text = convert_volume($Scroll/Container/Master/HBox/VolumeSlider.value)

func _on_audio_master_volume_slider_value_changed(v):
	settings["audio"]["master"]["volume"] = v
	AudioServer.set_bus_volume_db(0,v)
	$Scroll/Container/Master/HBox/VolumeLabel.text = convert_volume(v)


func _on_audio_ui_mute_activated(state):
	AudioServer.set_bus_mute(1,state)
	settings["audio"]["ui"]["mute"] = state
	$Scroll/Container/UI/HBox/VolumeSlider.editable = !state
	if state == true:
		$Scroll/Container/UI/HBox/VolumeLabel.text = "Volume : muted"
	else:
		$Scroll/Container/UI/HBox/VolumeLabel.text = convert_volume($Scroll/Container/UI/HBox/VolumeSlider.value)

func _on_audio_ui_volume_slider_value_changed(v):
	settings["audio"]["ui"]["volume"] = v
	AudioServer.set_bus_volume_db(1,v)
	$Scroll/Container/UI/HBox/VolumeLabel.text = convert_volume(v)


func _on_audio_ui_sfx_mute_activated(state):
	AudioServer.set_bus_mute(2,state)
	settings["audio"]["ui_sfx"]["mute"] = state
	$Scroll/Container/UI_SFX/HBox/VolumeSlider.editable = !state
	if state == true:
		$Scroll/Container/UI_SFX/HBox/VolumeLabel.text = "Volume : muted"
	else:
		$Scroll/Container/UI_SFX/HBox/VolumeLabel.text = convert_volume($Scroll/Container/UI_SFX1/HBox/VolumeSlider.value)


func _on_audio_ui_sfx_volume_slider_value_changed(v):
	settings["audio"]["ui_sfx"]["volume"] = v
	AudioServer.set_bus_volume_db(2,v)
	$Scroll/Container/UI_SFX/HBox/VolumeLabel.text = convert_volume(v)
