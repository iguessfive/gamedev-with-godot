extends GPUParticles3D
## A visual effect that emits confetti particles and auto-destructs after a delay.

func _ready() -> void:
	emitting = true
	await get_tree().create_timer(1.0).timeout
	queue_free()
