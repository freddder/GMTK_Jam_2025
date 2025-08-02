class_name FishPlayerCharacter
extends FishCharacter

signal profile_update

func _ready() -> void:
	set_profile(FishProfile.create())
	super._ready()



func set_profile(in_profile: FishProfile) -> void:
	if profile != null and profile.level > 0:
		EventBus.on_player_reincarnated.emit(profile)

	super.set_profile(in_profile)
	profile_update.emit()
