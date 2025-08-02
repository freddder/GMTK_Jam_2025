class_name FishCharacter
extends Node2D

signal on_inventory_changed
signal on_took_damage(health_lost: int)

@onready var health_bar : ProgressBar = %HealthBar
@onready var action_bar : ProgressBar = %ActionBar


var profile: FishProfile

# The inventory has to limit
var inventory: Array[Item]

var body: String = "debug_body"
var tail: String = "debug_tail"
var deco: String = "debug_deco"

var curr_health: int = 0
var curr_action_amount: float = 0.0


func _ready() -> void:
	on_took_damage.connect(_on_damage_taken)


func increase_action_amount(amount: float) -> void:
	curr_action_amount += amount
	action_bar.value = curr_action_amount


func set_profile(in_profile: FishProfile) -> void:
	profile = in_profile

	print("Set profile: ", profile._to_string())


func deal_damage(damage: int) -> int:
	var scaled_damage: float = damage

	# Decrease scaled damage by 30%; the effect stacks up, but is weaker
	# 10.0 -> 7.0 -> 4.9 -> 3.43 ...
	for item in inventory:
		if item.type == Item.Type.BUBBLE_SHIELD:
			scaled_damage *= 0.7

	# Round up: make sure to deal at least 1 damage
	var final_damage: int = max(1, ceil(scaled_damage))

	curr_health -= final_damage
	on_took_damage.emit(final_damage)

	if curr_health > 0:
		shake(2.5, 0.03, 20)

	return final_damage


func _on_damage_taken(health_lost: int) -> void:
	update_health_bar()


func get_max_health() -> int:
	return max(profile.attributes.data[Attributes.Type.Health], 1) * 5


func update_health_bar():
	var max_health := get_max_health()
	health_bar.value = (float(curr_health) / float(max_health)) * 100.0


func add_item(item: Item) -> void:
	assert(item != null)
	inventory.append(item)
	on_inventory_changed.emit()


func dissolve(duration: float) -> void:
	var tween := get_tree().create_tween()
	tween.tween_property(self, "material:shader_parameter/dissolve_value", 0.0, duration)
	await tween.finished


func shake(amplitude: float, duration: float, count: int) -> void:
	var tween := get_tree().create_tween()
	for i in count:
		var destination := Vector2(randf_range(-amplitude, amplitude), randf_range(-amplitude, amplitude))
		tween.tween_property(%Sprite2D, "position", destination, duration)

	tween.play()
	await tween.finished
