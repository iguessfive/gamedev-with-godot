extends Node3D

@onready var animation_player: AnimationPlayer = %AnimationPlayer


func _ready():
	animation_player.play("default")
	await get_tree().create_timer(4.0).timeout
	queue_free()
