class_name FishCharacter
extends Node2D

var attributes: Attributes
var profile: FishProfile

var body: String = "debug_body"
var tail: String = "debug_tail"
var deco: String = "debug_deco"

var curr_health: int
var curr_action_amount: float = 0.0
signal took_damage(health_lost: int)

@onready var health_bar : ProgressBar = $Control/VBoxContainer/HealthBar
@onready var action_bar : ProgressBar = $Control/VBoxContainer/ActionBar

func _ready() -> void:
	attributes = Attributes.create()
	curr_health = attributes.Type.Health

	took_damage.connect(update_health_bar)

func _process(delta):
	# TODO: not run battle manager logic when it's not a battle
	if action_bar != null:
		action_bar.value = curr_action_amount / BattleManager.action_bar_max_amount

func set_profile(in_profile: FishProfile) -> void:
	profile = in_profile

# Returns amount of damage taken
func get_attacked(incoming_damage: int) -> int:
	# TODO: check if fish has a shield

	curr_health -= incoming_damage
	took_damage.emit(incoming_damage)
	return incoming_damage

func update_health_bar():
	health_bar.value = curr_health / attributes.Type.Health
