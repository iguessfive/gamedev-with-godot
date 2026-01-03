extends Node3D

var active := false:
	set = _set_active
var track_curve: Curve3D = null
var track_tween: Tween = null

@onready var _silhouette_target_mesh: MeshInstance3D = %SilhouetteTargetMesh
@onready var _hit_area: HurtBox3D = %HitArea
@onready var _visual_root: Node3D = %VisualRoot
@onready var _active_timer: Timer = %ActiveTimer


func _ready() -> void:
	_visual_root.position.y -= 2
	# TODO: the player is not missing damage being dealt to the hurt box
	# Also rename hit area to hurtbox
	_hit_area.took_hit.connect(
		func _on_hit(_hit_position: Vector3):
			_active_timer.stop()
			var hit_tween := create_tween()
			hit_tween.set_ease(Tween.EASE_OUT)

			var rotation_tweener := hit_tween.tween_property(_visual_root, "rotation_degrees:x", -25.0, 0.1)
			rotation_tweener.set_trans(Tween.TRANS_BACK)

			var emission_tweener := hit_tween.parallel().tween_property(_silhouette_target_mesh.material_override, "emission_energy_multiplier", 1.5, 0.1)
			emission_tweener.set_trans(Tween.TRANS_BACK)

			var rotation_back_tweener := hit_tween.tween_property(_visual_root, "rotation_degrees:x", 0.0, 0.6)
			rotation_back_tweener.set_trans(Tween.TRANS_ELASTIC)

			var emission_fade_tweener := hit_tween.parallel().tween_property(_silhouette_target_mesh.material_override, "emission_energy_multiplier", 0.0, 0.1)
			emission_fade_tweener.set_delay(0.2).set_trans(Tween.TRANS_BACK)

			var callback_tweener := hit_tween.parallel().tween_callback(func(): active = false)
			callback_tweener.set_delay(0.25)
	)
	_active_timer.timeout.connect(
		func toggle_active() -> void:
			active = not active
	)

	if track_curve != null:
		var duration := track_curve.get_baked_length() / 2.0
		track_tween = create_tween()
		track_tween.set_ease(Tween.EASE_IN_OUT)
		track_tween.set_loops(0)
		track_tween.tween_method(_animate_moving_along_track, 0.0, 1.0, duration)
		track_tween.tween_method(_animate_moving_along_track, 1.0, 0.0, duration)


func _animate_moving_along_track(progress: float):
	position = track_curve.sample_baked(progress * track_curve.get_baked_length())


func _set_active(value: bool) -> void:
	if active == value:
		return
	active = value

	var activation_tween := create_tween()
	var position_tweener := activation_tween.tween_property(_visual_root, "position:y", 0.0 if active else -2.0, 0.5)
	position_tweener.set_trans(Tween.TRANS_BACK)
	position_tweener.set_ease(Tween.EASE_OUT)

	_active_timer.start(randf_range(3.0, 6.0))
