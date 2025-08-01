extends Node2D

@onready var player: FishPlayerCharacter = get_tree().get_first_node_in_group("player")
@onready var battle_scene := preload("res://scenes/battle.tscn")

var active_battle: Battle


func _ready() -> void:
	EventBus.promote_player_mating.connect(_promote_mating)
	EventBus.on_game_started.emit()

	# Start the game by mating; this will need to be moved after initial cut-scene
	_promote_mating()


func _promote_mating() -> void:
	var initial_fish_profiles := FishRandomizer.randomize_many(3, player.profile.level,
	player.profile.attributes, player.inventory)
	var rewards := FishProfile.to_reward_array(initial_fish_profiles)

	$RewardSelectionScreen.show_rewards(rewards)


func _promote_random_rewards() -> void:
	var rewards := Item.to_reward_array(Item.get_random_count(3))
	$RewardSelectionScreen.show_rewards(rewards)


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
