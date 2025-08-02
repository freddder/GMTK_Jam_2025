extends Node

signal close_text_box

var is_text_box_shown : bool = false

func _ready():
	# Initialize TextBox scene on the tree
	var scene = load("res://globals/TextBox.tscn")
	var instance = scene.instantiate()
	get_tree().root.add_child.call_deferred(instance)

	close_text_box.connect(on_close_text_box)

func update_text(text: String, auto_close_time: float = 0.0):
	var text_box : MarginContainer = get_node("/root/TextBox/MarginContainer")
	var text_label : RichTextLabel = text_box.get_node("RichTextLabel")
	text_label.clear()
	text_label.add_text(text)

	var tween := create_tween()
	tween.set_trans(Tween.TRANS_QUART)
	if not is_text_box_shown:
		is_text_box_shown = true
		tween.tween_property(text_box, "position:y", -text_box.size.y, 1).as_relative()
		if auto_close_time != 0.0:
			tween.tween_callback(on_close_text_box).set_delay(auto_close_time)

func on_close_text_box():
	if not is_text_box_shown:
		return
	is_text_box_shown = false
	var text_box : MarginContainer = get_node("/root/TextBox/MarginContainer")
	var tween := create_tween()
	tween.tween_property(text_box, "position:y", text_box.size.y, 1).as_relative().set_trans(Tween.TRANS_QUART)
