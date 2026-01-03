class_name PlayerEffectArea
extends Area3D

enum Effects { HEAL, HURT, RELOAD_AMMO }

@export var state: Effects = Effects.HEAL
@export var effect_amount := 10

var colors: Dictionary[Effects, Color] = {
	Effects.HEAL: Color("#1a9c45"),
	Effects.HURT: Color("#ff3414"),
	Effects.RELOAD_AMMO: Color("#337eff"),
}

@onready var icon: MeshInstance3D = %Icon
@onready var light: MeshInstance3D = %Light


func _ready() -> void:
	light.material_override.set_shader_parameter("albedo", colors[state])

	var tween := create_tween().set_loops(0)
	tween.tween_property(icon, "rotation_degrees:y", 360.0, 2.0).from(0.0)

	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node3D) -> void:
	var player := body as PlayerFPSController
	if player == null:
		return

	match state:
		Effects.HEAL:
			player.stats.add_health(effect_amount)
		Effects.HURT:
			player.stats.take_damage(effect_amount)
		Effects.RELOAD_AMMO:
			player.weapon_stats.restore()
