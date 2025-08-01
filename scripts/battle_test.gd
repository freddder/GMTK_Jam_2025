extends Node

@onready var fish_1 : FishCharacter = $FishCharacter
@onready var fish_2 : FishCharacter = $FishCharacter2

func _ready():
	fish_1.set_profile(FishProfile.create())
	fish_2.set_profile(FishProfile.create())
	BattleManager.player_fish = fish_1
	BattleManager.enemy_fish = fish_2
	
	# 7 dmg every 4 secs
	fish_1.profile.attributes.data[Attributes.Type.Health] = 30
	fish_1.profile.attributes.data[Attributes.Type.Attack] = 7
	fish_1.profile.attributes.data[Attributes.Type.Speed] = 25
	
	# 14 dmg every 8.3 secs
	fish_2.profile.attributes.data[Attributes.Type.Health] = 19
	fish_2.profile.attributes.data[Attributes.Type.Attack] = 14
	fish_2.profile.attributes.data[Attributes.Type.Speed] = 12
	
	BattleManager.battle_start()
