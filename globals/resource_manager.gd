extends Node

enum TextureId {
	NONE,
	INVALID,
	COOL_FISH,
	GODOT_ICON,
	PLAYER_ICON,
	FIGHT_ICON,
	MATE_ICON,
	EVENT_ICON,
	H_PATH,
	L_DOWN_PATH,
	L_UP_PATH,
	T_DOWN_PATH,
	T_UP_PATH
}

var textures: Dictionary = {
	TextureId.INVALID: preload("res://icon.svg"),
	TextureId.COOL_FISH: preload("res://assets/sprites/cool_fish.png"),
	TextureId.GODOT_ICON: preload("res://icon.svg"),
	TextureId.PLAYER_ICON: preload("res://assets/sprites/Icons/fish_icon.png"),
	TextureId.FIGHT_ICON: preload("res://assets/sprites/Icons/fight_icon.png"),
	TextureId.MATE_ICON: preload("res://assets/sprites/Icons/heart_icon.png"),
	TextureId.EVENT_ICON: preload("res://assets/sprites/Icons/questionmark_icon.png"),
	TextureId.H_PATH: preload("res://assets/sprites/path/h_path.png"),
	TextureId.L_DOWN_PATH: preload("res://assets/sprites/path/l_down_path.png"),
	TextureId.L_UP_PATH: preload("res://assets/sprites/path/l_up_path.png"),
	TextureId.T_DOWN_PATH: preload("res://assets/sprites/path/t_down_path.png"),
	TextureId.T_UP_PATH: preload("res://assets/sprites/path/t_up_path.png")
}

enum FishPart {
	ORANGE,
	BLUE,
	BROWN,
	GREEN,
	HLMT,
	RED,
	TEAL,
	COUNT,
	DEBUG,
}

var fish_body: Dictionary = {
	FishPart.DEBUG: preload("res://icon.svg"),
	FishPart.ORANGE: preload("res://assets/sprites/bodies/orng_body.png"),
	FishPart.BLUE: preload("res://assets/sprites/bodies/blue_body.png"),
	FishPart.BROWN: preload("res://assets/sprites/bodies/brown_body.png"),
	FishPart.GREEN: preload("res://assets/sprites/bodies/green_body.png"),
	FishPart.HLMT: preload("res://assets/sprites/bodies/hlmt_body.png"),
	FishPart.RED: preload("res://assets/sprites/bodies/red_body.png"),
	FishPart.TEAL: preload("res://assets/sprites/bodies/teal_body.png")
}

var fish_tail: Dictionary = {
	FishPart.DEBUG :preload("res://icon.svg"),
	FishPart.ORANGE: preload("res://assets/sprites/tails/orng_tail.png"),
	FishPart.BLUE: preload("res://assets/sprites/tails/blue_tail.png"),
	FishPart.BROWN: preload("res://assets/sprites/tails/brown_tail.png"),
	FishPart.GREEN: preload("res://assets/sprites/tails/green_tail.png"),
	FishPart.HLMT: preload("res://assets/sprites/tails/hlmt_tail.png"),
	FishPart.RED: preload("res://assets/sprites/tails/red_tail.png"),
	FishPart.TEAL: preload("res://assets/sprites/tails/teal_tail.png")
}

var fish_fin: Dictionary = {
	FishPart.DEBUG: preload("res://icon.svg"),
	FishPart.ORANGE: preload("res://assets/sprites/decorations/orng_fin.png"),
	FishPart.BLUE: preload("res://assets/sprites/decorations/blue_fin.png"),
	FishPart.BROWN: preload("res://assets/sprites/decorations/brown_fin.png"),
	FishPart.GREEN: preload("res://assets/sprites/decorations/green_fin.png"),
	FishPart.HLMT: preload("res://assets/sprites/decorations/hlmt_fin.png"),
	FishPart.RED: preload("res://assets/sprites/decorations/red_fin.png"),
	FishPart.TEAL: preload("res://assets/sprites/decorations/teal_fin.png")
}
