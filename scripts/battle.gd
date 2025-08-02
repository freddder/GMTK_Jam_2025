class_name Battle
extends Node

enum Winner {
	INVALID,
	PLAYER,
	OPPONENT
}

signal on_battle_finished(winner: Winner)

@onready var player_socket: Node2D = $PlayerSocket
@onready var player: FishPlayerCharacter = get_tree().get_first_node_in_group("player")
@onready var opponent: FishCharacter = $Opponent

var is_battle_active: bool = false
var action_bar_max_amount: float = 100.0


func _ready():
	player_socket.add_child(player)
	opponent.set_profile(randomize_enemy_profile(player.profile.level))


func start_battle() -> void:
	is_battle_active = true


func _on_battle_finished(winner: Winner) -> void:
	print("Battle winner: ", winner);

	# TODO: show the winner and whatnot, right now it'll close the window the moment someone dies

	is_battle_active = false
	on_battle_finished.emit(winner)


func _process(delta: float) -> void:
	if not is_battle_active:
		return

	player.curr_action_amount += player.profile.attributes.data[Attributes.Type.Speed] * delta
	opponent.curr_action_amount += opponent.profile.attributes.data[Attributes.Type.Speed] * delta

	if player.curr_action_amount >= action_bar_max_amount:
		print("player attack")
		var total_attack_power = player.profile.attributes.data[Attributes.Type.Attack]
		opponent.get_attacked(total_attack_power)
		player.curr_action_amount -= action_bar_max_amount

	if opponent.curr_action_amount >= action_bar_max_amount:
		print("enemy attack")
		var total_attack_power = opponent.profile.attributes.data[Attributes.Type.Attack]
		player.get_attacked(total_attack_power)
		opponent.curr_action_amount -= action_bar_max_amount

	if opponent.curr_health <= 0:
		_on_battle_finished(Winner.PLAYER)
	elif player.curr_health <= 0:
		_on_battle_finished(Winner.OPPONENT)


func randomize_enemy_profile(player_level: int) -> FishProfile:
	var profile := FishProfile.create()

	var level: float = int(player_level + randf_range(-2.0, 2.0))
	profile.title = FishNicknamePool.request_unique_names(1)[0]
	profile.level = round(level)

	for i in profile.level:
		var shuffled_attributes := Attributes.shuffled_attributes()
		for attribute in shuffled_attributes:
			var bound := profile.level + 2
			var value := randi_range(0, bound)
			profile.attributes.data[attribute] += value

	# Minimum 1 attribute
	for attribute in profile.attributes.data.size():
		profile.attributes.data[attribute] = max(1, profile.attributes.data[attribute])

	return profile
