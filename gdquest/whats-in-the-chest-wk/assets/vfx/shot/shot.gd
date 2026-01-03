extends Node3D
## Visual effect for a weapon shot with particles and wave effects.

@onready var wave: MeshInstance3D = %Wave
@onready var particles: GPUParticles3D = %Particles


func _ready() -> void:
	var random_duration := randf_range(0.2, 0.4)
	var top_duration := random_duration * 1.8
	particles.lifetime = top_duration
	particles.emitting = true

	var effect_tween := create_tween().set_parallel(true)
	effect_tween.tween_property(wave.material_override, "shader_parameter/fade", 0.0, random_duration).from(1.0)
	effect_tween.tween_property(wave.material_override, "shader_parameter/wave_offset", 0.2, random_duration).from(-0.5)
	effect_tween.tween_property(wave, "scale", Vector3.ONE * randf_range(1.4, 2.0), random_duration).from(Vector3.ONE * 0.5)

	await get_tree().create_timer(top_duration).timeout
	queue_free()
