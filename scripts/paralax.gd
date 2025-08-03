extends Node2D
class_name Paralax

@onready var layer_1 : Parallax2D = $ParallaxLayer1
@onready var layer_2 : Parallax2D = $ParallaxLayer2

var enable_scroll : bool = false

func _process(delta):
	if not enable_scroll:
		return
	
	layer_1.scroll_offset.x -= delta * 200
	layer_2.scroll_offset.x -= delta * 300
