extends Node3D
## A visual impact effect that plays a sound and animation before self-destructing.

@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var impact_sound: AudioStreamPlayer3D = %ImpactSound


func _ready() -> void:
	animation_player.play("default")
	await get_tree().create_timer(4.0).timeout
	queue_free()
