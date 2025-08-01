extends Node2D

@export var min_volume_db: float = -30.0
@export var max_volume_db: float = 0.0

var bgm_bus_idx := 1
var sfx_bus_idx := 2

func _ready() -> void:
	$Settings.visible = false

	var bgm_slider_value := 1.0 - (AudioServer.get_bus_volume_db(bgm_bus_idx) / min_volume_db)
	%Slider_Music.set_value_no_signal(bgm_slider_value)
	AudioServer.set_bus_mute(bgm_bus_idx, bgm_slider_value == 0.0)

	var sfx_slider_value := 1.0 - (AudioServer.get_bus_volume_db(sfx_bus_idx) / min_volume_db)
	%Slider_SFX.set_value_no_signal(sfx_slider_value)
	AudioServer.set_bus_mute(sfx_bus_idx, sfx_slider_value == 0.0)

func _on_button_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_level.tscn")


func _on_button_settings_pressed() -> void:
	$Settings.visible = true


func _on_slider_music_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(bgm_bus_idx, lerp(min_volume_db, max_volume_db, value))
	AudioServer.set_bus_mute(bgm_bus_idx, value == 0.0)


func _on_slider_sfx_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(sfx_bus_idx, lerp(min_volume_db, max_volume_db, value))
	AudioServer.set_bus_mute(sfx_bus_idx, value == 0.0)


func _on_button_close_settings_pressed() -> void:
	$Settings.visible = false
