extends Node

var _total_cleared_tiles: int = 0


func _ready() -> void:
	EventBus.on_game_started.connect(_on_game_started)


func _on_game_started() -> void:
	_total_cleared_tiles = 0


func on_tile_cleared() -> void:
	_total_cleared_tiles += 1

	if _total_cleared_tiles % GameSettings.tiles_to_clear_for_mating == 0:
		EventBus.promote_player_mating.emit()