extends CanvasLayer

@export var water_ripple_scene := preload("res://scenes/water_ripple.tscn")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("lmb"):
		var ripple: WaterRipple = water_ripple_scene.instantiate()
		add_child(ripple)

		ripple.global_position = get_viewport().get_mouse_position()
