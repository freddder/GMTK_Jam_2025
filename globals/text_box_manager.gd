extends Node

func _ready():
	# Initialize TextBox scene on the tree
	var scene = load("res://globals/TextBox.tscn")
	var instance = scene.instantiate()
	get_tree().root.add_child.call_deferred(instance)

func update_text(text: String):
	var text_box : MarginContainer = get_node("/root/TextBox/MarginContainer")
	var text_label : RichTextLabel = text_box.get_node("RichTextLabel")
	text_label.clear()
	text_label.add_text(text)

	text_box.position.y += text_box.size.y
	var tween := create_tween()
	tween.tween_property(text_box, "position:y", -text_box.size.y, 1).as_relative().set_trans(Tween.TRANS_QUART)
