extends Node2D

func _ready() -> void:
	EventBus.on_game_started.emit()
