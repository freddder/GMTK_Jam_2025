class_name Item
extends Resource

enum Type {
	INVALID,
	FAKE_VAMPIRE_TEETH,
	CONTACT_LENSES,
	MOTIVATIONAL_POSTER,
	BROKEN_CALCULATOR,
	SELECTIVE_EYE,
	BUBBLE_SHIELD,
}

@export var icon: CompressedTexture2D
@export var title: String
@export var description: String
@export var type := Type.INVALID

static var items: Dictionary = {
	Type.FAKE_VAMPIRE_TEETH: load("res://assets/items/fake_vampire_teeth.tres"),
	Type.CONTACT_LENSES: load("res://assets/items/contact_lenses.tres"),
	Type.MOTIVATIONAL_POSTER: load("res://assets/items/motivational_poster.tres"),
	Type.BROKEN_CALCULATOR: load("res://assets/items/broken_calculator.tres"),
	Type.SELECTIVE_EYE: load("res://assets/items/selective_eye.tres"),
	Type.BUBBLE_SHIELD: load("res://assets/items/bubble_shield.tres")
}


func to_reward() -> RewardOptionData:
	var option := RewardOptionData.new()

	option.type = RewardOptionData.Type.INVENTORY_ITEM
	option.icon = icon
	option.title = title
	option.description = description
	option.item_type = type

	return option


static func to_reward_array(items: Array[Item]) -> Array[RewardOptionData]:
	var result: Array[RewardOptionData]
	result.resize(items.size())

	for i in items.size():
		result[i] = items[i].to_reward()

	return result


static func from_reward(reward: RewardOptionData) -> Item:
	assert(reward.type == RewardOptionData.Type.INVENTORY_ITEM)

	var found = items[reward.item_type]
	assert(found != null)

	return found


static func get_random_count(count: int) -> Array[Item]:
	assert(count > 0 and items.size() >= count)

	var pool: Array = items.values()

	pool.shuffle()
	pool.resize(count)

	var result: Array[Item]
	result.resize(count)
	for i in pool.size():
		result[i] = pool[i]

	return result
