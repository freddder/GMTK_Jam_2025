extends Node

var fishOptions = ["orng", "blue", "brown", "green", "hlmt", "red", "teal"]


# dictionary for the sprites, will have to be filled in manualy
var BODIES = {
	"debug_body": preload("res://icon.svg"),
	"orng": preload("res://assets/sprites/bodies/orng_body.png"),
	"blue": preload("res://assets/sprites/bodies/blue_body.png"),
	"brown": preload("res://assets/sprites/bodies/brown_body.png"),
	"green": preload("res://assets/sprites/bodies/green_body.png"),
	"hlmt": preload("res://assets/sprites/bodies/hlmt_body.png"),
	"red": preload("res://assets/sprites/bodies/red_body.png"),
	"teal": preload("res://assets/sprites/bodies/teal_body.png")
}


var TAILS = {
	"debug_tail":preload("res://icon.svg"),
	"orng": preload("res://assets/sprites/tails/orng_tail.png"),
	"blue": preload("res://assets/sprites/tails/blue_tail.png"),
	"brown": preload("res://assets/sprites/tails/brown_tail.png"),
	"green": preload("res://assets/sprites/tails/green_tail.png"),
	"hlmt": preload("res://assets/sprites/tails/hlmt_tail.png"),
	"red": preload("res://assets/sprites/tails/red_tail.png"),
	"teal": preload("res://assets/sprites/tails/teal_tail.png")
}


var DECORATIONS = {
	"debug_deco": preload("res://icon.svg"),
	"orng": preload("res://assets/sprites/decorations/orng_fin.png"),
	"blue": preload("res://assets/sprites/decorations/blue_fin.png"),
	"brown": preload("res://assets/sprites/decorations/brown_fin.png"),
	"green": preload("res://assets/sprites/decorations/green_fin.png"),
	"hlmt": preload("res://assets/sprites/decorations/hlmt_fin.png"),
	"red": preload("res://assets/sprites/decorations/red_fin.png"),
	"teal": preload("res://assets/sprites/decorations/teal_fin.png")
}
