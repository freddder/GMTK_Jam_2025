class_name Battle
extends Node

enum Winner {
	INVALID,
	PLAYER,
	OPPONENT
}

signal on_battle_finished(winner: Winner)

@onready var original_player: FishPlayerCharacter = get_tree().get_first_node_in_group("player")
@onready var player: FishCharacter = $Player
@onready var opponent: FishCharacter = $Opponent

var is_battle_active: bool = false
var action_bar_max_amount: float = 100.0


func _ready():
	player.set_profile(original_player.profile)
	opponent.set_profile(randomize_enemy_profile(original_player.profile.level))

	player.curr_health = player.get_max_health()
	opponent.curr_health = opponent.get_max_health()

	player.update_health_bar()


func start_battle() -> void:
	is_battle_active = true


func _on_battle_finished(winner: Winner) -> void:
	is_battle_active = false

	print("Battle winner: ", winner);

	var to_dissolve: FishCharacter
	if winner == Winner.PLAYER:
		to_dissolve = opponent
	else:
		to_dissolve = player

	await to_dissolve.dissolve(2.0)

	await get_tree().create_timer(3.0).timeout

	is_battle_active = false
	on_battle_finished.emit(winner)


static func get_fish_speed(fish: FishCharacter) -> int:
	return max(fish.profile.attributes.data[Attributes.Type.Speed], 1)


func _attack_fish(attacker: FishCharacter, victim: FishCharacter) -> bool:
	if attacker.curr_action_amount >= action_bar_max_amount:
		attacker.curr_action_amount -= action_bar_max_amount

		var total_attack_power = attacker.profile.attributes.data[Attributes.Type.Attack]
		victim.deal_damage(total_attack_power)
		return victim.curr_health <= 0

	return false


func _process(delta: float) -> void:
	if not is_battle_active:
		return

	var player_speed := get_fish_speed(player)
	var opponent_speed := get_fish_speed(opponent)

	# The fastest attack should be always 2 seconds
	var constant_duration := 2.0
	var speed_scale := action_bar_max_amount / constant_duration

	# Scale down/up the attacks:
	# pl. speed 5, opp. speed 1 -> pl.speed 20, opp. speed 5;
	# pl. speed 3, opp. speed 40 -> pl.speed 1.5, opp. speed 20
	if player_speed >= opponent_speed:
		opponent_speed /= player_speed / speed_scale
		player_speed = speed_scale
	else:
		player_speed /= opponent_speed / speed_scale
		opponent_speed = speed_scale

	# Favor the player to make equal fights to be winnable
	player_speed *= 1.1

	player.increase_action_amount(player_speed * delta)
	opponent.increase_action_amount(opponent_speed * delta)

	if _attack_fish(player, opponent):
		_on_battle_finished(Winner.PLAYER)
	elif _attack_fish(opponent, player):
		_on_battle_finished(Winner.OPPONENT)


func randomize_enemy_profile(player_level: int) -> FishProfile:
	var profile := FishProfile.create()

	var level_bound: int = max(player_level / 3, 1)
	var level: float = int(player_level + randf_range(-level_bound, level_bound))
	profile.title = FishNicknamePool.request_unique_name()
	profile.level = round(level)

	for i in profile.level:
		var shuffled_attributes := Attributes.shuffled_attributes()
		for attribute in shuffled_attributes:
			var bound: int = max(profile.level, 1)
			if (player_level > 2):
				bound += 2

			var value := randi_range(0, bound)
			profile.attributes.data[attribute] += value

	# Minimum 1 attribute
	for attribute in profile.attributes.data.size():
		profile.attributes.data[attribute] = max(1, profile.attributes.data[attribute])

	return profile
