extends Node3D

@onready var animation_player: AnimationPlayer = %AnimationPlayer


func _ready():
	animation_player.play("default")
	var timer: SceneTreeTimer = get_tree().create_timer(2.0, false)
	timer.timeout.connect(queue_free)
