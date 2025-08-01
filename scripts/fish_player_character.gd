class_name FishPlayerCharacter
extends FishCharacter

signal on_inventory_changed

# The inventory has to limit
var inventory: Array[Item]


func _ready() -> void:
	set_profile(FishProfile.create())
	super._ready()


func set_profile(in_profile: FishProfile) -> void:
	if profile != null and profile.level > 0:
		EventBus.on_player_reincarnated.emit(profile)

	super.set_profile(in_profile)


func add_item(item: Item) -> void:
	assert(item != null)
	inventory.append(item)
	on_inventory_changed.emit()
