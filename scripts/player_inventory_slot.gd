class_name PlayerInventorySlot
extends Control

var _item: Item

func set_icon(item: Item) -> void:
	assert(item != null)

	_item = item
	%Icon.texture = _item.icon
	%Icon.tooltip_text = _item.description
