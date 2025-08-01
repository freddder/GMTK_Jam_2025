extends Node

enum TextureId {
	COOL_FISH,
	GODOT_ICON,
}

var textures: Dictionary = {
	TextureId.COOL_FISH: preload("res://assets/sprites/cool_fish.png"),
	TextureId.GODOT_ICON: preload("res://icon.svg"),
}
