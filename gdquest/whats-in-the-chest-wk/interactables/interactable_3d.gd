## Base class for 3D object that can be highlighted when the player aims at it
## and that the player can interact with.
##
## We do not use Area3D.mouse_entered and mouse_exited because:
##
## - We want to highlight the object when the player is looking at it, even if
## they play with the gamepad or release the mouse cursor from the game window.
## - We don't want to highlight the object when the player interacts with it or
## picks it up.
# ANCHOR: header
@tool
class_name Interactable3D
extends Area3D

## Emitted when the player interacts with the node.
signal interacted_with

const MATERIAL_HIGHLIGHT := preload("res://assets/highlight_overlay.tres")

@export var mesh_instances: Array[MeshInstance3D] = []:
	set = set_mesh_instances
@export var is_highlighted := false:
	set = set_is_highlighted
# END: header

var _material_highlight: ShaderMaterial = MATERIAL_HIGHLIGHT.duplicate()
var _tween: Tween = null


func _init() -> void:
	monitoring = false


func set_mesh_instances(new_mesh_instances: Array[MeshInstance3D]) -> void:
	mesh_instances = new_mesh_instances
	for mesh_instance in mesh_instances:
		if mesh_instance != null:
			if is_highlighted:
				mesh_instance.material_overlay = MATERIAL_HIGHLIGHT
			else:
				mesh_instance.material_overlay = null


func set_is_highlighted(new_value: bool) -> void:
	is_highlighted = new_value

	if mesh_instances.is_empty():
		return

	if _tween != null:
		_tween.kill()

	_tween = create_tween()

	# ANCHOR: material_highlight_duplicate_1
	var current_alpha: float = _material_highlight.get_shader_parameter("alpha")
	if is_highlighted:
		for mesh_instance in mesh_instances:
			mesh_instance.material_overlay = _material_highlight
	# END: material_highlight_duplicate_1
		_tween.tween_method(set_material_alpha, current_alpha, 1.0, 0.1)
	else:
		_tween.tween_method(set_material_alpha, current_alpha, 0.0, 0.1)
		_tween.tween_callback(
			func():
				for mesh_instance in mesh_instances:
					mesh_instance.material_overlay = null
		)


func set_material_alpha(alpha: float) -> void:
	# ANCHOR: material_highlight_duplicate_2
	_material_highlight.set_shader_parameter("alpha", alpha)
	# END: material_highlight_duplicate_2


## Virtual function. Called when interacting with the node.
## Override the function to make the interactable do something.
func interact() -> void:
	interacted_with.emit()
