class_name RewardOptionData

enum Type {
	INVALID,
	MATTING,
	INVENTORY_ITEM,
}

var type := Type.INVALID
var icon: CompressedTexture2D
var title: String
var description: String
var attributes: Attributes
var item_type: Item.Type


static func create() -> RewardOptionData:
	var this := RewardOptionData.new()
	this.attributes = Attributes.create()
	return this
