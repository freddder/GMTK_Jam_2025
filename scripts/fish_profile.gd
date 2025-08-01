class_name FishProfile

var icon: CompressedTexture2D
var title: String
var attributes: Attributes
var level: int

static func create() -> FishProfile:
	var this := FishProfile.new()
	this.attributes = Attributes.create()
	return this


func to_reward() -> RewardOptionData:
	var data := RewardOptionData.new()

	data.icon = icon
	data.title = title
	data.attributes = attributes

	return data


static func from_reward(level: int, data: RewardOptionData) -> FishProfile:
	var profile := FishProfile.new()

	profile.icon = data.icon
	profile.title = data.title
	profile.attributes = data.attributes
	profile.level = level

	return profile


static func to_reward_array(profiles: Array[FishProfile]) -> Array[RewardOptionData]:
	var result: Array[RewardOptionData]
	result.resize(profiles.size())

	for i in profiles.size():
		result[i] = profiles[i].to_reward()

	return result
