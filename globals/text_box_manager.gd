extends Node

signal close_text_box

@onready var scene := preload("res://scenes/text_box.tscn")
var dialog_box: MarginContainer
var dialog_label: RichTextLabel
var options_menu: MarginContainer

var is_text_box_shown: bool = false

func initialize():
	var instance := scene.instantiate()
	get_tree().root.add_child(instance)
	close_text_box.connect(on_close_text_box)
	
	dialog_box = instance.get_node("DialogBox")
	dialog_label = dialog_box.get_node("RichTextLabel")
	
	options_menu = instance.get_node("OptionsMenu")

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
