extends Node

enum TextureId {
	NONE,
	INVALID,
	COOL_FISH,
	GODOT_ICON,
	PLAYER_ICON,
	FIGHT_ICON,
	MATE_ICON,
	EVENT_ICON
}

var textures: Dictionary = {
	TextureId.INVALID: preload("res://icon.svg"),
	TextureId.COOL_FISH: preload("res://assets/sprites/cool_fish.png"),
	TextureId.GODOT_ICON: preload("res://icon.svg"),
	TextureId.PLAYER_ICON: preload("res://assets/sprites/Icons/fish_icon.png"),
	TextureId.FIGHT_ICON: preload("res://assets/sprites/Icons/fight_icon.png"),
	TextureId.MATE_ICON: preload("res://assets/sprites/Icons/heart_icon.png"),
	TextureId.EVENT_ICON: preload("res://assets/sprites/Icons/questionmark_icon.png")

}
