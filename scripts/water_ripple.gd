class_name WaterRipple
extends Control

var progress: float = 0.0
@export var speed: float = 2.0


func _process(delta: float) -> void:
	progress += delta * speed
	$ColorRect.material.set_shader_parameter("progress", progress)

	if progress >= 1.0:
		queue_free()
