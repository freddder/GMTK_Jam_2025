extends Node2D

var timer: float
@export var speed: float = 7

func _process(delta: float) -> void:
	timer += delta * speed
	position.y += sin(timer)
