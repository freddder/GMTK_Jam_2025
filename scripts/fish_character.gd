class_name FishCharacter
extends Node2D

var attributes: Attributes

var body: String = "debug_body"
var tail: String = "debug_tail"
var deco: String = "debug_deco"


func _ready() -> void:
	attributes = Attributes.create()


func apply_data(data: RewardOptionData) -> void:
	attributes = data.attributes
