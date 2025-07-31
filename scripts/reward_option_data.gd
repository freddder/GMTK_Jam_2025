class_name RewardOptionData

var title: String
var attributes: Attributes


static func create() -> RewardOptionData:
	var this := RewardOptionData.new()
	this.attributes = Attributes.create()
	return this
