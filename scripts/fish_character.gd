class_name FishCharacter
extends Node2D

var attributes: Attributes


func _ready() -> void:
	attributes = Attributes.create()


func apply_data(data: RewardOptionData) -> void:
	attributes = data.attributes
