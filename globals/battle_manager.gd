extends Node

var player_fish: FishCharacter
var enemy_fish: FishCharacter

var action_bar_max_amount: float = 100.0
var is_battle_active: bool = false

func _process(delta):
	if not is_battle_active:
		return

	player_fish.curr_action_amount += player_fish.attributes.data[Attributes.Type.Speed] * delta
	enemy_fish.curr_action_amount += enemy_fish.attributes.data[Attributes.Type.Speed] * delta

	if player_fish.curr_action_amount >= action_bar_max_amount:
		var total_attack_power = player_fish.attributes.data[Attributes.Type.Attack]
		enemy_fish.get_attacked(total_attack_power)
		player_fish.curr_action_amount -= action_bar_max_amount

	if enemy_fish.curr_action_amount >= action_bar_max_amount:
		var total_attack_power = enemy_fish.attributes.data[Attributes.Type.Attack]
		player_fish.get_attacked(total_attack_power)
		enemy_fish.curr_action_amount -= action_bar_max_amount

	if player_fish.curr_health <= 0:
		print("Enemy won")
		is_battle_active = false
	elif enemy_fish.curr_health <= 0:
		print("Plaeyer won")
		is_battle_active = false
