class_name RewardSelectionScreen
extends CanvasLayer

var options: Array[RewardOption]

func _ready() -> void:
	for child in $HBoxContainer.get_children():
		var option: RewardOption = child
		options.append(option)
		option.on_option_selected.connect(_on_option_selected)

	await get_tree().create_timer(0.5).timeout

	var test_options: Array[RewardOptionData]
	var size := options.size()
	var names := FishNicknamePool.request_unique_names(size)
	for i in size:
		var data := RewardOptionData.create()
		data.title = names[i]
		for attribute in data.attributes.data:
			data.attributes.data[attribute] = randi_range(-5, 5)

		test_options.append(data)

	show_rewards(test_options)


func show_rewards(data: Array[RewardOptionData]) -> void:
	for i in data.size():
		options[i].set_option_data(data[i])
	$HBoxContainer.visible = true


func _on_option_selected(option: RewardOption) -> void:
	$HBoxContainer.visible = false
