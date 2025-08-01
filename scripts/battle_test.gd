extends Node

@onready var fish_1 : FishCharacter = $FishCharacter
@onready var fish_2 : FishCharacter = $FishCharacter2

func _ready():
	BattleManager.player_fish = fish_1
	BattleManager.enemy_fish = fish_2
	BattleManager.is_battle_active = true
