class_name FishPlayerCharacter
extends FishCharacter

signal profile_update

func set_profile(in_profile: FishProfile) -> void:
	if profile != null and profile.level > 0:
		EventBus.on_player_reincarnated.emit(profile)

	super.set_profile(in_profile)
	profile_update.emit()


func add_item(item: Item) -> void:
	super.add_item(item)
	$BubbleShield.visible = get_inventory_item_count(Item.Type.BUBBLE_SHIELD) > 0
