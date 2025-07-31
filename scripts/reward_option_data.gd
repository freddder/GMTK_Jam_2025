class_name RewardOptionData

var icon: Texture2D
var title: String
var description: String
var attributes: Attributes


static func create() -> RewardOptionData:
	var this := RewardOptionData.new()
	this.attributes = Attributes.create()
	return this
