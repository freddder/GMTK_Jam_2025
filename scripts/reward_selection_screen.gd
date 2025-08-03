class_name RewardSelectionScreen
extends CanvasLayer

signal on_option_selected(option: RewardOptionData)

@onready var player: FishPlayerCharacter = get_tree().get_first_node_in_group("player")

var options: Array[RewardOption]


func _ready() -> void:
	visible = false

	for child in %HBoxContainer.get_children():
		var option: RewardOption = child
		options.append(option)
		option.on_option_selected.connect(_on_option_selected)


func show_rewards(data: Array[RewardOptionData]) -> void:
	if data[0].type == RewardOptionData.Type.MATING:
		%Label_Title.text = "Choose a fish to breed with"
	else:
		%Label_Title.text = "Choose your reward"

	for option in options:
		option.visible = false

	for i in data.size():
		options[i].visible = true
		options[i].set_option_data(data[i])

	visible = true


func _on_option_selected(option: RewardOption) -> void:
	visible = false

	match option.data.type:
		RewardOptionData.Type.MATING:
			player.set_profile(FishProfile.from_reward(player.profile.level + 1, option.data))
		RewardOptionData.Type.INVENTORY_ITEM:
			player.add_item(Item.from_reward(option.data))

	on_option_selected.emit(option.data)
	$"../UpgradeSFX".play()
