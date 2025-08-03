extends Node

signal close_text_box

@onready var scene := preload("res://scenes/text_box.tscn")
var dialog_box: MarginContainer
var dialog_label: RichTextLabel

var options_menu: MarginContainer
var options_button_1: Button
var options_button_2: Button
var options_button_3: Button
signal option_selected(index: int)

var is_text_box_shown: bool = false

func initialize():
	var instance := scene.instantiate()
	get_tree().root.add_child(instance)
	close_text_box.connect(on_close_text_box)
	
	dialog_box = instance.get_node("DialogBox")
	dialog_label = dialog_box.get_node("RichTextLabel")
	
	options_menu = instance.get_node("OptionsMenu")
	options_menu.hide()
	options_button_1 = options_menu.get_node("VBoxContainer/Option1")
	options_button_2 = options_menu.get_node("VBoxContainer/Option2")
	options_button_3 = options_menu.get_node("VBoxContainer/Option3")
	options_button_1.button_down.connect(on_option_1_selected)
	options_button_2.button_down.connect(on_option_2_selected)
	options_button_3.button_down.connect(on_option_3_selected)

func display_text(text: String, auto_close_time: float = 0.0):
	dialog_label.clear()
	dialog_label.add_text(text)

	var tween := create_tween()
	tween.set_trans(Tween.TRANS_QUART)
	if not is_text_box_shown:
		is_text_box_shown = true
		tween.tween_property(dialog_box, "position:y", -dialog_box.size.y, 1).as_relative()
		if auto_close_time != 0.0:
			tween.tween_callback(on_close_text_box).set_delay(auto_close_time)

func on_close_text_box():
	if not is_text_box_shown:
		return

	is_text_box_shown = false
	var tween := create_tween()
	tween.tween_property(dialog_box, "position:y", dialog_box.size.y, 1).as_relative().set_trans(Tween.TRANS_QUART)

func on_option_1_selected():
	on_option_selected(1)

func on_option_2_selected():
	on_option_selected(2)

func on_option_3_selected():
	on_option_selected(3)

func on_option_selected(index: int):
	options_menu.hide()
	option_selected.emit(index)

func display_options(option_1_text : String, option_2_text : String, option_3_text : String = "") -> int:
	if option_1_text == "" or option_2_text == "":
		return 0
	
	options_button_1.text = option_1_text
	options_button_2.text = option_2_text
	
	options_menu.show()
	if option_3_text != "":
		options_button_3.show()
		options_button_3.text = option_3_text
	else:
		options_button_3.hide()
	
	var picked_option = await option_selected
	return picked_option
