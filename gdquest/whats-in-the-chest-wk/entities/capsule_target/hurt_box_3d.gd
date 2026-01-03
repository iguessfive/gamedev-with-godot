class_name HurtBox3D
extends Area3D

signal took_hit(hit_global_position: Vector3)


func take_hit(hit_position: Vector3) -> void:
	took_hit.emit(hit_position)
	Events.projectile_hit.emit()
