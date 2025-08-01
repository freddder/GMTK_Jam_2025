class_name FishPlayerCharacter
extends FishCharacter


func _ready() -> void:
	super._ready()


func set_profile(in_profile: FishProfile) -> void:
	if profile != null and profile.level > 0:
		EventBus.on_player_reincarnated.emit(profile)

	super.set_profile(in_profile)
