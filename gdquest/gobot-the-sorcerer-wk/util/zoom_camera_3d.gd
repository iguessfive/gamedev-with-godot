extends Node

@export var camera: Camera3D

var target_fov = 60.0
var zoom_speed = 0.1

func _process(_delta: float) -> void:
	camera.fov = lerp(camera.fov, target_fov, zoom_speed)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			camera.translate_object_local(Vector3.FORWARD)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			camera.translate_object_local(Vector3.FORWARD)
