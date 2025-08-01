extends Node2D

@onready var player: FishPlayerCharacter = get_tree().get_first_node_in_group("player")


func _ready() -> void:
	EventBus.on_game_started.emit()

	# Start the game by mating; this will need to be moved after initial cut-scene
	_promote_mating()


func _promote_mating() -> void:
	var initial_fish_profiles := FishRandomizer.randomize_many(
		3, player.profile.level, player.profile.attributes)
	var rewards := FishProfile.to_reward_array(initial_fish_profiles)

	$RewardSelectionScreen.show_rewards(rewards)


func _promote_random_rewards() -> void:
	var rewards := Item.to_reward_array(Item.get_random_count(3))
	$RewardSelectionScreen.show_rewards(rewards)
