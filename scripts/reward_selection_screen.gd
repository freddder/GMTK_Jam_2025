class_name RewardSelectionScreen
extends CanvasLayer

@onready var player: FishCharacter = get_tree().get_first_node_in_group("player")

var options: Array[RewardOption]

func _ready() -> void:
	for child in $HBoxContainer.get_children():
		var option: RewardOption = child
		options.append(option)
		option.on_option_selected.connect(_on_option_selected)

	player.set_profile(FishProfile.create())
	_DEBUG_propose_breeding()


func show_rewards(data: Array[RewardOptionData]) -> void:
	for option in options:
		option.visible = false

	for i in data.size():
		options[i].visible = true
		options[i].set_option_data(data[i])

	$HBoxContainer.visible = true


func _on_option_selected(option: RewardOption) -> void:
	$HBoxContainer.visible = false
	player.set_profile(FishProfile.from_reward(player.profile.level + 1, option.data))
	_DEBUG_propose_breeding()


func _DEBUG_propose_breeding() -> void:
	await get_tree().create_timer(0.5).timeout

	var test_options := FishProfile.to_reward_array(
		FishRandomizer.randomize_many(
			3, player.profile.level, player.profile.attributes))

	show_rewards(test_options)
