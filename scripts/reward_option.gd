class_name RewardOption
extends Control

signal on_option_selected(option: RewardOption)

@onready var player: FishPlayerCharacter = get_tree().get_first_node_in_group("player")

@export var better_color: Color = Color(0.3372549, 0.91764706, 0.13333334)
@export var worse_color: Color = Color(0.89411765, 0.22352941, 0.22352941)
@export var same_color: Color = Color(0.94509804, 0.8784314, 0.29803923)

var attribute_labels: Array[Label]

var data: RewardOptionData


class LabelData:
	var str: String
	var color: Color

func _ready() -> void:
	attribute_labels.resize(Attributes.Type.Count)
	attribute_labels[Attributes.Type.Health] = %Label_Health
	attribute_labels[Attributes.Type.Attack] = %Label_Attack
	attribute_labels[Attributes.Type.Speed] = %Label_Speed


func _get_data_for_attribute(reward_data: RewardOptionData, attribute: Attributes.Type) -> LabelData:
	var label_data := LabelData.new()

	var lhs: int = player.profile.attributes.data[attribute]
	var rhs: int = reward_data.attributes.data[attribute]
	var diff := rhs - lhs

	if diff > 0:
		label_data.str = "%+d" % [diff]
		label_data.color = better_color
	elif diff < 0:
		label_data.str = "%+d" % [diff]
		label_data.color = worse_color
	else:
		label_data.str = "-"
		label_data.color = same_color

	return label_data


func _handle_attributes(reward_data: RewardOptionData) -> void:
	%AttributesContainer.visible = true

	for attribute in Attributes.Type.Count:
		var label: Label = attribute_labels[attribute]

		var label_data := _get_data_for_attribute(reward_data, attribute)

		if player.profile.level == 0:
			label.text = "%s: %d" % [Attributes.type_to_string(attribute),
				data.attributes.data[attribute]]
		else:
			label.text = "%s: %s" % [Attributes.type_to_string(attribute),
				label_data.str]
			label.self_modulate = label_data.color


func set_option_data(reward_data: RewardOptionData) -> void:
	data = reward_data

	%Icon1.texture = data.icon
	%Label_Title.text = data.title
	%Label_Description.text = data.description

	%AttributesContainer.visible = false
	if reward_data.type == RewardOptionData.Type.MATING:
		_handle_attributes(reward_data)
		%Icon1.texture = ResourceManager.fish_body[reward_data.cosmetics[0]]
		%Icon2.texture = ResourceManager.fish_tail[reward_data.cosmetics[1]]
		%Icon3.texture = ResourceManager.fish_fin[reward_data.cosmetics[2]]
		%Icon2.visible = true
		%Icon3.visible = true
	else:
		%Icon2.visible = false
		%Icon3.visible = false


func _on_button_down() -> void:
	on_option_selected.emit(self)
