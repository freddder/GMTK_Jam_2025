extends Node2D

@onready var battle_scene := load("res://scenes/battle.tscn")
@onready var final_battle_scene := load("res://scenes/battle_boss.tscn")
@onready var player: FishPlayerCharacter = $PlayerCharacter
@onready var map_scene := $TimelineManager
@onready var events_manager : EventManager = $EventManager

@onready var main_theme_player : AudioStreamPlayer = $MainTheme
@onready var battle_theme_player : AudioStreamPlayer = $BattleTheme
@onready var reward_theme_player : AudioStreamPlayer = $RewardTheme
@onready var victory_theme_player : AudioStreamPlayer = $VictoryTheme
@onready var death_theme_player : AudioStreamPlayer = $DeathTheme

var active_battle: Battle
var can_handle_action_input: bool = false


func _ready() -> void:
	EventBus.promote_player_mating.connect(_promote_mating)
	map_scene.on_tile_landed.connect(_on_tile_landed)
	$PauseMenu.on_activation_state_changed.connect(_on_activation_state_changed)

	EventBus.on_game_started.emit()
	TextBoxManager.initialize()

	$HUD.hide()
	await opening_cutscene()


func on_player_death() -> void:
	can_handle_action_input = false
	var tween := get_tree().create_tween()
	tween.tween_property($deathScreen, "color", Color(.1,.1,.1,1), 2)
	play_death_theme()

	await get_tree().create_timer(2.0).timeout

	map_scene.reset_path()
	$HUD.hide()

	opening_cutscene()


func opening_cutscene() -> void:
	#_start_game()
	#return

	$deathScreen.color = Color(.7,.7,.7,0)

	var tweener := get_tree().create_tween()
	$MageFish.position = Vector2(2500, 1000)
	await tweener.tween_property($MageFish, "position", Vector2(1500, 500), 1.0).set_ease(Tween.EASE_IN_OUT).finished

	await get_tree().create_timer(0.1).timeout

	tweener = get_tree().create_tween()
	tweener.tween_property($MageFish, "position:x", 1300, 3)
	tweener.tween_property($MageFish, "position:x", 1500, 3)
	tweener.set_loops(2)

	TextBoxManager.display_text("I will curse you for what you have done to me")
	await get_tree().create_timer(5.0).timeout

	TextBoxManager.display_text("You will now swim forever, reincarnating in an endless loop of torment")
	await get_tree().create_timer(5.0).timeout

	await TextBoxManager.on_close_text_box()

	tweener.stop()
	await get_tree().create_timer(1.0).timeout

	$MageFish.scale.x = -1.0
	await get_tree().create_timer(0.5).timeout

	tweener = get_tree().create_tween()
	await tweener.tween_property($MageFish, "position", Vector2(3000, 0), 0.5).finished

	$MageFish.scale.x = 1.0

	resume_main_theme()
	_start_game()



func _start_game() -> void:
	player.set_profile(FishProfile.create())

	# Reset the inventory, but leave one item
	if not player.inventory.is_empty():
		var item: Item = player.inventory.pick_random()
		player.inventory.clear()
		player.add_item(item)

	await _promote_mating()
	map_scene.initialize()
	$HUD.show()


func _input(event: InputEvent) -> void:
	if can_handle_action_input:
		if event.is_action_pressed("lmb"):
			map_scene.on_action_completed(false)

	if event.is_action_pressed("pause"):
		$PauseMenu.set_active(true)


func _on_tile_landed(type: TimelineManager.Type) -> void:
	$Paralax.enable_scroll = false
	match type:
		TimelineManager.Type.FIGHT:
			var winner: Battle.Winner = await _start_battle(false)
			if winner == Battle.Winner.PLAYER:
				await _promote_random_rewards()
			else:
				on_player_death()

		TimelineManager.Type.MATE:
			await _promote_mating()

		TimelineManager.Type.EVENT:
			can_handle_action_input = false
			await events_manager.start_random_event()
			can_handle_action_input = true

		TimelineManager.Type.BOSS:
			await _play_pre_final_battle_cutscene()

			var winner: Battle.Winner = await _start_battle(true)
			if winner == Battle.Winner.PLAYER:
				await _play_final_cutscene()
			else:
				await on_player_death()

			active_battle.queue_free()
			can_handle_action_input = true

		TimelineManager.Type.PATH_UP:
			can_handle_action_input = false
			var option: int = await TextBoxManager.display_options("Go forward", "Go up")
			map_scene.on_action_completed(option == 2)
			can_handle_action_input = true

		TimelineManager.Type.PATH_DOWN:
			can_handle_action_input = false
			var option: int = await TextBoxManager.display_options("Go forward", "Go down")
			map_scene.on_action_completed(option == 2)
			can_handle_action_input = true

		TimelineManager.Type.RETURN_DOWN:
			map_scene.on_action_completed(true)

		TimelineManager.Type.RETURN_UP:
			map_scene.on_action_completed(true)


func _promote_mating() -> void:
	can_handle_action_input = false
	%PlayerInventory.visible = false

	var initial_fish_profiles := FishRandomizer.randomize_many(3, player.profile.level,
	player.profile.attributes, player.inventory)
	var rewards := FishProfile.to_reward_array(initial_fish_profiles)

	$RewardSelectionScreen.show_rewards(rewards)
	await $RewardSelectionScreen.on_option_selected

	can_handle_action_input = true
	%PlayerInventory.visible = true


func _promote_random_rewards() -> void:
	transition_theme_to_reward()
	can_handle_action_input = false

	var rewards := Item.to_reward_array(Item.get_random_count(3))
	$RewardSelectionScreen.show_rewards(rewards)
	await $RewardSelectionScreen.on_option_selected

	transition_theme_to_main()
	can_handle_action_input = true


func _start_battle(is_boss: bool) -> Battle.Winner:
	player.hide()
	transition_theme_to_battle()
	can_handle_action_input = false

	assert(active_battle == null)

	if not is_boss:
		active_battle = battle_scene.instantiate()
	else:
		active_battle = final_battle_scene.instantiate()

	get_tree().get_current_scene().add_child(active_battle)

	active_battle.start_battle()
	var winner: Battle.Winner = await active_battle.on_battle_finished

	if not is_boss:
		active_battle.queue_free()
		can_handle_action_input = true

	player.show()

	return winner


func transition_theme_to_main():
	print("to main")
	var tween := create_tween()
	tween.tween_property(main_theme_player, "volume_db", -20, 0.5)
	tween.tween_property(battle_theme_player, "volume_db", -50, 0.5)
	tween.tween_property(reward_theme_player, "volume_db", -50, 0.5)

func play_death_theme():
	death_theme_player.play()
	main_theme_player.stop()
	battle_theme_player.stop()
	reward_theme_player.stop()

func resume_main_theme():
	death_theme_player.stop()
	main_theme_player.play()
	battle_theme_player.play()
	reward_theme_player.play()

func transition_theme_to_battle():
	print("to battle")
	var tween := create_tween()
	tween.tween_property(main_theme_player, "volume_db", -50, 0.5)
	tween.tween_property(battle_theme_player, "volume_db", -20, 0.5)
	tween.tween_property(reward_theme_player, "volume_db", -50, 0.5)


func transition_theme_to_reward():
	print("to reward")
	var tween := create_tween()
	tween.tween_property(main_theme_player, "volume_db", -50, 0.5)
	tween.tween_property(battle_theme_player, "volume_db", -50, 0.5)
	tween.tween_property(reward_theme_player, "volume_db", -20, 0.5)


func _on_activation_state_changed(is_active: bool) -> void:
	can_handle_action_input = not is_active
	get_tree().paused = is_active


func _play_pre_final_battle_cutscene() -> void:
	var tweener := get_tree().create_tween()
	$MageFish.position = Vector2(3000, 0)
	await tweener.tween_property($MageFish, "position", Vector2(1500, 500), 0.75).set_ease(Tween.EASE_IN_OUT).finished

	await get_tree().create_timer(0.1).timeout

	tweener = get_tree().create_tween()
	tweener.tween_property($MageFish, "position:x", 1300, 3)
	tweener.tween_property($MageFish, "position:x", 1500, 3)
	tweener.set_loops(2)

	TextBoxManager.display_text("You want to face me, huh? There's no way that you're going to win!")
	await get_tree().create_timer(5.0).timeout

	await TextBoxManager.on_close_text_box()

	tweener.stop()
	tweener = get_tree().create_tween()
	await tweener.tween_property($MageFish, "modulate:a", 0.0, 0.5).finished

	$MageFish.position = Vector2(3000, 0)
	$MageFish.modulate.a = 1.0


func _play_final_cutscene() -> void:
	TextBoxManager.display_text("But... how...?")
	await get_tree().create_timer(5.0).timeout

	transition_theme_to_victory()
	TextBoxManager.display_text("Victory?")

	# TODO: Commented out because I don't really want the music to play
	# for 2 seconds
	#get_tree().change_scene_to_file("res://scenes/main_menu.tscn")



func transition_theme_to_victory():
	print("to victory")

	var tween := create_tween()
	tween.tween_property(main_theme_player, "volume_db", -80, 0.5)
	tween.tween_property(battle_theme_player, "volume_db", -80, 0.5)
	tween.tween_property(reward_theme_player, "volume_db", -80, 0.5)

	victory_theme_player.play()
