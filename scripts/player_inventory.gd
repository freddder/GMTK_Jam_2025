extends Control

@onready var player: FishPlayerCharacter = get_tree().get_first_node_in_group("player")
@onready var slot_scene := preload("res://scenes/player_inventory_slot.tscn")

func _ready() -> void:
	player.on_inventory_changed.connect(_on_inventory_changed)
	_on_inventory_changed()


func _on_inventory_changed() -> void:
	for i in range($HBoxContainer.get_child_count(), player.inventory.size()):
		var slot: PlayerInventorySlot = slot_scene.instantiate()
		$HBoxContainer.add_child(slot)
		slot.set_icon(player.inventory[i])
