extends Node2D

@onready var battle_scene := preload("res://scenes/battle.tscn")
@onready var player := $PlayerCharacter
@onready var map_scene := $TimelineManager

var active_battle: Battle


func _ready() -> void:
	EventBus.promote_player_mating.connect(_promote_mating)
	EventBus.on_game_started.emit()
	map_scene.on_tile_landed.connect(_on_tile_landed)

	# Start the game by mating; this will need to be moved after initial cut-scene
	await _promote_mating()
	map_scene.initialize()



func _on_tile_landed(type: TimelineManager.Type) -> void:
	match type:
		TimelineManager.Type.FIGHT:
			await _start_battle()
			await _promote_random_rewards()
			map_scene.on_action_completed(false)

		TimelineManager.Type.MATE:
			await _promote_mating()
			map_scene.on_action_completed(false)


func _promote_mating() -> void:
	var initial_fish_profiles := FishRandomizer.randomize_many(3, player.profile.level,
	player.profile.attributes, player.inventory)
	var rewards := FishProfile.to_reward_array(initial_fish_profiles)

	$RewardSelectionScreen.show_rewards(rewards)
	await $RewardSelectionScreen.on_option_selected


func _promote_random_rewards() -> void:
	var rewards := Item.to_reward_array(Item.get_random_count(3))
	$RewardSelectionScreen.show_rewards(rewards)
	await $RewardSelectionScreen.on_option_selected


func _start_battle() -> void:
	assert(active_battle == null)

	active_battle = battle_scene.instance()
	get_tree().root.add_child(active_battle)

	active_battle.start_battle()
	var winner: Battle.Winner = await active_battle.on_battle_finished

	if winner == Battle.Winner.PLAYER:
		GameState.on_tile_cleared()

	# TODO: if we're going to use the same player node instance everywhere,
	# make sure to return it back to the main scene once battle scene is over,
	# as currently it attaches the player to its root to correctly display it
	get_tree().root.add_child(player)
	active_battle.queue_free()
