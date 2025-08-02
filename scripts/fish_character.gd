class_name FishCharacter
extends Node2D

signal on_inventory_changed
signal on_took_damage(health_lost: int)
signal on_healed(health_received: int)
signal on_life_stolen(life_stolen: int)
signal on_crit_rolled

@onready var health_bar : ProgressBar = %HealthBar
@onready var action_bar : ProgressBar = %ActionBar

# The inventory has to limit
@export var inventory: Array[Item]

var profile: FishProfile

var body: String = "debug_body"
var tail: String = "debug_tail"
var deco: String = "debug_deco"

var curr_health: int = 0
var curr_action_amount: float = 0.0
var sent_hits: int = 0


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
	scaled_damage *= pow(0.7, get_inventory_item_count(Item.Type.BUBBLE_SHIELD))

	# Round up: make sure to deal at least 1 damage
	var final_damage: int = max(1, ceil(scaled_damage))

	curr_health -= final_damage
	on_took_damage.emit(final_damage)

	if curr_health > 0:
		shake(2.5, 0.03, 20)

	return final_damage


func heal(value: int) -> void:
	var new_health: int = min(get_max_health(), curr_health + value)
	if curr_health != new_health:
		var delta := new_health + curr_health
		curr_health = new_health

		on_healed.emit(delta)


func _on_damage_taken(health_lost: int) -> void:
	update_health_bar()


func get_max_health() -> int:
	return max(profile.attributes.data[Attributes.Type.Health], 1) * 5


func get_normalized_health() -> float:
	var max := get_max_health()
	var ratio := float(curr_health) / float(max)
	return ratio


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


func prepare_to_battle() -> void:
	curr_health = get_max_health()
	update_health_bar()
	sent_hits = 0


func get_inventory_item_count(type: Item.Type) -> int:
	var count: int = 0
	for item in inventory:
		if item.type == type:
			count += 1

	return count


func get_damage() -> int:
	var calculator_count := get_inventory_item_count(Item.Type.BROKEN_CALCULATOR)

	var damage = profile.attributes.data[Attributes.Type.Attack]
	damage += calculator_count * sent_hits

	if get_normalized_health() <= 0.25:
		var poster_count := get_inventory_item_count(Item.Type.MOTIVATIONAL_POSTER)
		damage *= pow(1.25, poster_count)

	var lens_count := get_inventory_item_count(Item.Type.CONTACT_LENSES)
	for i in lens_count:
		if randf() > 0.75:
			damage *= 2
			on_crit_rolled.emit()

	return damage


func on_attack_sent(damage: int) -> void:
	sent_hits += 1

	var teeth_count := get_inventory_item_count(Item.Type.FAKE_VAMPIRE_TEETH)
	if teeth_count > 0:
		var value := damage * pow(0.4, teeth_count)
		heal(value)
		on_life_stolen.emit(value)
