extends Area3D

func _ready() -> void:
	body_entered.connect(
		func(body: PlayerFPSController) -> void:
			if body != null:
				get_tree().reload_current_scene.call_deferred()
	)
