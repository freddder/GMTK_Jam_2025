extends Control

@onready var player: FishPlayerCharacter = get_tree().get_first_node_in_group("player")
@onready var slot_scene := preload("res://scenes/player_inventory_slot.tscn")

@onready var health_label : Label = $StatsMenu/MarginContainer/VBoxContainer/HBoxContainer/HealthLabel
@onready var attack_label : Label = $StatsMenu/MarginContainer/VBoxContainer/HBoxContainer2/AttackLabel
@onready var speed_label : Label = $StatsMenu/MarginContainer/VBoxContainer/HBoxContainer3/SpeedLabel

func _ready() -> void:
	player.on_inventory_changed.connect(_on_inventory_changed)
	_on_inventory_changed()
	player.profile_update.connect(update_stats_menu)


func _on_inventory_changed() -> void:
	for i in range($HBoxContainer.get_child_count(), player.inventory.size()):
		var slot: PlayerInventorySlot = slot_scene.instantiate()
		$HBoxContainer.add_child(slot)
		slot.set_icon(player.inventory[i])

func update_stats_menu():
	health_label.text = str(player.profile.attributes.data[Attributes.Type.Health])
	attack_label.text = str(player.profile.attributes.data[Attributes.Type.Attack])
	speed_label.text = str(player.profile.attributes.data[Attributes.Type.Speed])
