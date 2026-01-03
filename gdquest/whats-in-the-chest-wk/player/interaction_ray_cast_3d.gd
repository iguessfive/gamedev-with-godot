class_name InteractionRayCast3D
extends RayCast3D
## Allows the player to interact with objects in the scene using a raycast.
## The length of the ray determines from where the player can interact with
## objects.

var _focused_node: Interactable3D = null


func _init() -> void:
	enabled = false

	collide_with_bodies = false
	collide_with_areas = true


func _physics_process(_delta: float) -> void:
	force_raycast_update()
	var collider := get_collider() as Interactable3D

	if collider == null and _focused_node != null:
		_focused_node.is_highlighted = false

	_focused_node = collider
	if _focused_node != null:
		_focused_node.is_highlighted = true


func _unhandled_input(event: InputEvent) -> void:
	if _focused_node != null and event.is_action_pressed("interact"):
		_focused_node.interact()
