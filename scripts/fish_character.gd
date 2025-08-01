class_name FishCharacter
extends Node2D

signal took_damage(health_lost: int)

var profile: FishProfile

var body: String = "debug_body"
var tail: String = "debug_tail"
var deco: String = "debug_deco"

var curr_health: int = 0
var curr_action_amount: float = 0.0

@onready var health_bar : ProgressBar = $Control/VBoxContainer/HealthBar
@onready var action_bar : ProgressBar = $Control/VBoxContainer/ActionBar


func _ready() -> void:
	took_damage.connect(update_health_bar)

func _process(delta):
	# TODO: toimplement Tony
	pass
	# TODO: not run battle manager logic when it's not a battle
	#if action_bar != null:
		#action_bar.value = float(curr_action_amount) / float(BattleManager.action_bar_max_amount) * 100.0

func set_profile(in_profile: FishProfile) -> void:
	profile = in_profile

# Returns amount of damage taken
func get_attacked(incoming_damage: int) -> int:
	# TODO: check if fish has a shield

	curr_health -= incoming_damage
	took_damage.emit(incoming_damage)
	return incoming_damage

func update_health_bar(asm: int):
	health_bar.value = float(curr_health) / float(profile.attributes.data[Attributes.Type.Health]) * 100.0
