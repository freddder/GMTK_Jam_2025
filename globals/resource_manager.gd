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
	T_UP_PATH,
	SUS_KELP,
	SUNKEN_SLOT_MACHINE,
	MERCHANT,
	SAD_FISH
}

var textures := {
	TextureId.INVALID: load("res://icon.svg"),
	TextureId.COOL_FISH: load("res://assets/sprites/cool_fish.png"),
	TextureId.GODOT_ICON: load("res://icon.svg"),
	TextureId.PLAYER_ICON: load("res://assets/sprites/Icons/fish_icon.png"),
	TextureId.FIGHT_ICON: load("res://assets/sprites/Icons/fight_icon.png"),
	TextureId.MATE_ICON: load("res://assets/sprites/Icons/heart_icon.png"),
	TextureId.EVENT_ICON: load("res://assets/sprites/Icons/questionmark_icon.png"),
	TextureId.H_PATH: load("res://assets/sprites/path/h_path.png"),
	TextureId.L_DOWN_PATH: load("res://assets/sprites/path/l_down_path.png"),
	TextureId.L_UP_PATH: load("res://assets/sprites/path/l_up_path.png"),
	TextureId.T_DOWN_PATH: load("res://assets/sprites/path/t_down_path.png"),
	TextureId.T_UP_PATH: load("res://assets/sprites/path/t_up_path.png"),
	TextureId.SUS_KELP: load("res://assets/sprites/items/SUS_kelp.png"),
	TextureId.SUNKEN_SLOT_MACHINE: load("res://assets/sprites/items/Sunken_slot_machine.png"),
	TextureId.MERCHANT: load("res://assets/sprites/items/Merchant.png"),
	TextureId.SAD_FISH: load("res://assets/sprites/items/sad_fish.png")
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

var fish_body := {
	FishPart.DEBUG: load("res://icon.svg"),
	FishPart.ORANGE: load("res://assets/sprites/bodies/orng_body.png"),
	FishPart.BLUE: load("res://assets/sprites/bodies/blue_body.png"),
	FishPart.BROWN: load("res://assets/sprites/bodies/brown_body.png"),
	FishPart.GREEN: load("res://assets/sprites/bodies/green_body.png"),
	FishPart.HLMT: load("res://assets/sprites/bodies/hlmt_body.png"),
	FishPart.RED: load("res://assets/sprites/bodies/red_body.png"),
	FishPart.TEAL: load("res://assets/sprites/bodies/teal_body.png")
}

var fish_tail := {
	FishPart.DEBUG :load("res://icon.svg"),
	FishPart.ORANGE: load("res://assets/sprites/tails/orng_tail.png"),
	FishPart.BLUE: load("res://assets/sprites/tails/blue_tail.png"),
	FishPart.BROWN: load("res://assets/sprites/tails/brown_tail.png"),
	FishPart.GREEN: load("res://assets/sprites/tails/green_tail.png"),
	FishPart.HLMT: load("res://assets/sprites/tails/hlmt_tail.png"),
	FishPart.RED: load("res://assets/sprites/tails/red_tail.png"),
	FishPart.TEAL: load("res://assets/sprites/tails/teal_tail.png")
}

var fish_fin := {
	FishPart.DEBUG: load("res://icon.svg"),
	FishPart.ORANGE: load("res://assets/sprites/decorations/orng_fin.png"),
	FishPart.BLUE: load("res://assets/sprites/decorations/blue_fin.png"),
	FishPart.BROWN: load("res://assets/sprites/decorations/brown_fin.png"),
	FishPart.GREEN: load("res://assets/sprites/decorations/green_fin.png"),
	FishPart.HLMT: load("res://assets/sprites/decorations/hlmt_fin.png"),
	FishPart.RED: load("res://assets/sprites/decorations/red_fin.png"),
	FishPart.TEAL: load("res://assets/sprites/decorations/teal_fin.png")
}
