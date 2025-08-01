extends Node

var data: Array[FishProfile]

func _ready() -> void:
	EventBus.on_game_started.connect(_on_game_started)
	EventBus.on_player_reincarnated.connect(_on_player_reincarnated)


func _on_game_started() -> void:
	data.clear()


func _on_player_reincarnated(previous_profile: FishProfile) -> void:
	data.append(previous_profile)
	print("Parent ", data.size(), ": ", previous_profile._to_string())
