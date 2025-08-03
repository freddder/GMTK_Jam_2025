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
	FishPart.ORANGE: load("res://assets/sprites/bodies/orng_body.PNG"),
	FishPart.BLUE: load("res://assets/sprites/bodies/blue_body.PNG"),
	FishPart.BROWN: load("res://assets/sprites/bodies/brown_body.PNG"),
	FishPart.GREEN: load("res://assets/sprites/bodies/green_body.PNG"),
	FishPart.HLMT: load("res://assets/sprites/bodies/hlmt_body.PNG"),
	FishPart.RED: load("res://assets/sprites/bodies/red_body.PNG"),
	FishPart.TEAL: load("res://assets/sprites/bodies/teal_body.PNG")
}

var fish_tail := {
	FishPart.DEBUG :load("res://icon.svg"),
	FishPart.ORANGE: load("res://assets/sprites/tails/orng_tail.PNG"),
	FishPart.BLUE: load("res://assets/sprites/tails/blue_tail.PNG"),
	FishPart.BROWN: load("res://assets/sprites/tails/brown_tail.PNG"),
	FishPart.GREEN: load("res://assets/sprites/tails/green_tail.PNG"),
	FishPart.HLMT: load("res://assets/sprites/tails/hlmt_tail.PNG"),
	FishPart.RED: load("res://assets/sprites/tails/red_tail.PNG"),
	FishPart.TEAL: load("res://assets/sprites/tails/teal_tail.PNG")
}

var fish_fin := {
	FishPart.DEBUG: load("res://icon.svg"),
	FishPart.ORANGE: load("res://assets/sprites/decorations/orng_fin.PNG"),
	FishPart.BLUE: load("res://assets/sprites/decorations/blue_fin.PNG"),
	FishPart.BROWN: load("res://assets/sprites/decorations/brown_fin.PNG"),
	FishPart.GREEN: load("res://assets/sprites/decorations/green_fin.PNG"),
	FishPart.HLMT: load("res://assets/sprites/decorations/hlmt_fin.PNG"),
	FishPart.RED: load("res://assets/sprites/decorations/red_fin.PNG"),
	FishPart.TEAL: load("res://assets/sprites/decorations/teal_fin.PNG")
}
