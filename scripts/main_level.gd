extends Node2D

@onready var battle_scene := load("res://scenes/battle.tscn")
@onready var player := $PlayerCharacter
@onready var map_scene := $TimelineManager

var active_battle: Battle
var can_handle_action_input: bool = false


func _ready() -> void:
	EventBus.promote_player_mating.connect(_promote_mating)
	EventBus.on_game_started.emit()
	map_scene.on_tile_landed.connect(_on_tile_landed)

	# Start the game by mating; this will need to be moved after initial cut-scene
	await _promote_mating()
	map_scene.initialize()


func _input(event: InputEvent) -> void:
	if can_handle_action_input:
		if event.is_action_pressed("lmb"):
			map_scene.on_action_completed(false)


func _on_tile_landed(type: TimelineManager.Type) -> void:
	match type:
		TimelineManager.Type.FIGHT:
			var winner: Battle.Winner = await _start_battle()

			if winner == Battle.Winner.PLAYER:
				await _promote_random_rewards()
				GameState.on_tile_cleared()
			else:
				# TODO: player has lost: return them back to square 1 with original stats
				assert(false)
				pass

		TimelineManager.Type.MATE:
			await _promote_mating()

		TimelineManager.Type.EVENT:
			print("weed")

		TimelineManager.Type.BOSS:
			print("boss fight")


func _promote_mating() -> void:
	can_handle_action_input = false

	var initial_fish_profiles := FishRandomizer.randomize_many(3, player.profile.level,
	player.profile.attributes, player.inventory)
	var rewards := FishProfile.to_reward_array(initial_fish_profiles)

	$RewardSelectionScreen.show_rewards(rewards)
	await $RewardSelectionScreen.on_option_selected

	can_handle_action_input = true


func _promote_random_rewards() -> void:
	can_handle_action_input = false

	var rewards := Item.to_reward_array(Item.get_random_count(3))
	$RewardSelectionScreen.show_rewards(rewards)
	await $RewardSelectionScreen.on_option_selected

	can_handle_action_input = true


func _start_battle() -> Battle.Winner:
	can_handle_action_input = false

	assert(active_battle == null)

	active_battle = battle_scene.instantiate()
	get_tree().root.add_child(active_battle)

	active_battle.start_battle()
	var winner: Battle.Winner = await active_battle.on_battle_finished

	active_battle.queue_free()
	can_handle_action_input = true

	return winner
