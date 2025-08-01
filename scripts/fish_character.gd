class_name FishCharacter
extends Node2D

var attributes: Attributes
var profile: FishProfile

var body: String = "debug_body"
var tail: String = "debug_tail"
var deco: String = "debug_deco"


func _ready() -> void:
	attributes = Attributes.create()


func set_profile(in_profile: FishProfile) -> void:
	profile = in_profile
