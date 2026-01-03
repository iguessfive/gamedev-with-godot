extends Node3D

@export_range(1, 10, 1) var target_count := 3

@onready var path_3d: Path3D = %Path3D
@onready var silhouette_target_scene: PackedScene = preload("silhouette_target.tscn")


func _ready() -> void:
	if target_count > 1:
		for index in target_count:
			var percent := index / float(target_count - 1)
			var target := silhouette_target_scene.instantiate()
			var distance_along_path := path_3d.curve.get_baked_length() * percent
			target.position = path_3d.curve.sample_baked(distance_along_path)
			path_3d.add_child(target)
	else:
		var target := silhouette_target_scene.instantiate()
		var random_distance_along_path := path_3d.curve.get_baked_length() * randf()
		target.position = path_3d.curve.sample_baked(random_distance_along_path)
		target.track_curve = path_3d.curve
		path_3d.add_child(target)
