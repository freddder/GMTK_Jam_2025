extends Node2D

@onready var mage_fish := load("res://scenes/mage_fish.tscn")

@onready var battle_scene := load("res://scenes/battle.tscn")
@onready var player := $PlayerCharacter
@onready var map_scene := $TimelineManager

@onready var main_theme_player : AudioStreamPlayer = $MainTheme
@onready var battle_theme_player : AudioStreamPlayer = $BattleTheme
@onready var reward_theme_player : AudioStreamPlayer = $RewardTheme

var active_battle: Battle
var can_handle_action_input: bool = false
var mage :Node2D

func _ready() -> void:
	EventBus.promote_player_mating.connect(_promote_mating)
	EventBus.on_game_started.emit()
	map_scene.on_tile_landed.connect(_on_tile_landed)
	TextBoxManager.call_deferred("initialize")
	$HUD.hide()
	call_deferred("opening_cutscene")
	

func on_player_death() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property($deathScreen, "color", Color(.1,.1,.1,1), 2)
	
	await get_tree().create_timer(2.0).timeout
	
	map_scene.reset_path()
	$HUD.hide()
	
	opening_cutscene()
	
	pass

func opening_cutscene() -> void:
	$deathScreen.color = Color(.7,.7,.7,0)
	mage = mage_fish.instantiate()
	mage.position = Vector2 (1000,500)
	var tweener = get_tree().create_tween()
	tweener.tween_property(mage, "position:x", 1500,3)
	tweener.tween_property(mage, "position:x", 1000,3)
	tweener.set_loops(5)
	add_child(mage)
	
	TextBoxManager.display_text("I will curse you for what you have done to me", 9)
	await get_tree().create_timer(5.0).timeout
	
	TextBoxManager.display_text("You will now swim forever, reincarnating in an endless loop of torment", 0)
	await get_tree().create_timer(5.0).timeout
	
	mage.hide()
	
	await _promote_mating()
	map_scene.initialize()
	$HUD.show()
	pass

func _input(event: InputEvent) -> void:
	if can_handle_action_input:
		if event.is_action_pressed("lmb"):
			map_scene.on_action_completed(false)
	
	if event is InputEventKey and event.is_pressed():
		if event.keycode == KEY_ESCAPE:
			get_tree().change_scene_to_file("res://scenes/main_menu.tscn")


func _on_tile_landed(type: TimelineManager.Type) -> void:
	match type:
		TimelineManager.Type.FIGHT:
			var winner: Battle.Winner = await _start_battle()

			if winner == Battle.Winner.PLAYER:
				await _promote_random_rewards()
			else:
				# TODO: reset the player's stats
				on_player_death()
				
				pass

		TimelineManager.Type.MATE:
			await _promote_mating()

		TimelineManager.Type.EVENT:
			TextBoxManager.display_options("Hello", "World", "Maybe")

			print("weed")

		TimelineManager.Type.BOSS:
			# TODO: actually do something with the boss fight
			var winner: Battle.Winner = await _start_battle()

			if winner == Battle.Winner.PLAYER:
				await _promote_random_rewards()
			else:
				# TODO: player has lost: return them back to square 1 with original stats
				assert(false)
				pass

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


func _start_battle() -> Battle.Winner:
	transition_theme_to_battle()
	can_handle_action_input = false

	assert(active_battle == null)

	active_battle = battle_scene.instantiate()
	get_tree().root.add_child(active_battle)

	active_battle.start_battle()
	var winner: Battle.Winner = await active_battle.on_battle_finished

	active_battle.queue_free()
	can_handle_action_input = true

	return winner

func transition_theme_to_main():
	print("to main")
	var tween := create_tween()
	tween.tween_property(main_theme_player, "volume_db", -20, 0.5)
	tween.tween_property(battle_theme_player, "volume_db", -50, 0.5)
	tween.tween_property(reward_theme_player, "volume_db", -50, 0.5)

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
