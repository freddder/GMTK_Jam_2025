class_name EventManager
extends Node2D

@onready var sprite : Sprite2D = $EventSprite
@onready var player: FishPlayerCharacter = get_tree().get_first_node_in_group("player")

func start_random_event():
	var pool: Array[int]

	# Offer the slot machine only when there's enough items
	if player.inventory.size() >= 2:
		pool.append(3);

	# Offer to swap items only when there's any
	if not player.inventory.is_empty():
		pool.append(2);

	# Always offer kelp and dialog
	pool.append_array([1, 4])

	var is_early_sprite_out: bool = false
	var event_id: int = pool.pick_random()
	create_tween().tween_property(sprite, "position:x", 1500, 1).set_trans(Tween.TRANS_QUART).finished
	match event_id:
		1:
			TextBoxManager.display_text("You found a piece of kelp that has been left alone for a bit too long but still looks (kinda) edible. Do you eat it?")
			sprite.texture = ResourceManager.textures[ResourceManager.TextureId.SUS_KELP]
			await get_tree().create_timer(1.0).timeout
			var answer := await TextBoxManager.display_options("Yes", "No")
			if answer == 1:
				var success := randi() % 2
				var msg: String
				if success:
					player.profile.attributes.data[Attributes.Type.Health] += 10
					msg = "Health was increased"
				else:
					player.profile.attributes.data[Attributes.Type.Health] -= 10
					msg = "Health was decreased"

				player.set_profile(player.profile)
				await TextBoxManager.display_text(msg, 2.0)
		2:
			TextBoxManager.display_text("You found a mystery trader. Would you like to swap your items for other random items?")
			sprite.texture = ResourceManager.textures[ResourceManager.TextureId.MERCHANT]
			await get_tree().create_timer(1.0).timeout
			var answer := await TextBoxManager.display_options("Yes", "No")
			var amount := player.inventory.size()
			if answer == 1 and amount != 0:
				player.inventory.clear()
				player.add_random_items(amount)
			await TextBoxManager.on_close_text_box()
		3:
			TextBoxManager.display_text("You came across a sunken slot machine and it looks like it still works. Do you want to gamble for double the amount of items inserted?")
			sprite.texture = ResourceManager.textures[ResourceManager.TextureId.SUNKEN_SLOT_MACHINE]
			await get_tree().create_timer(1.0).timeout
			var answer := await TextBoxManager.display_options("Insert 2 random items", "Insert 1 random item", "Insert no items")
			if answer != 3 and not player.inventory.is_empty() and randi_range(0, 1) == 0:
				player.remove_random_item()
				player.add_random_items(2)
				if answer == 1 and player.inventory.size() > 2:
					player.remove_random_item()
					player.add_random_items(2)

			await TextBoxManager.on_close_text_box()
		4:
			TextBoxManager.display_text("You stumble upon another fish in a bad mood. How do you want to help?")
			sprite.texture = ResourceManager.textures[ResourceManager.TextureId.SAD_FISH]
			await get_tree().create_timer(1.0).timeout
			var answer := await TextBoxManager.display_options("Tell a bad joke", "Ask about their problems")
			if answer == 1:
				if randi() % 2 == 0:
					await TextBoxManager.display_text("They liked it! Maybe a bit too much...", 2)
					EventBus.promote_player_mating.emit()
					await EventBus.on_player_reincarnated
				else:
					create_tween().tween_property(sprite, "position:x", 2200, 1).set_trans(Tween.TRANS_QUART).finished
					is_early_sprite_out = true
					await TextBoxManager.display_text("It seems your joke was worse than expected... They simply left", 2)
			else:
				await TextBoxManager.display_text("After talking about it, they seem to feel slightly better. And so do you", 2)
				# TODO: increase forgiveness
	if not is_early_sprite_out:
		await create_tween().tween_property(sprite, "position:x", 2200, 1).set_trans(Tween.TRANS_QUART).finished
