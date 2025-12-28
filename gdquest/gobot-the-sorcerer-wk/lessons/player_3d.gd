extends CharacterBody3D

const GRAVITY = 40.0 * Vector3.DOWN

@export var max_speed: float = 5.0
@export var steering_factor: float = 5.0 # direct impact on change in direction

var input = LocalPlayerInputs.new()

var _ground_plane := Plane(Vector3.UP)

@onready var _skin: GobotSkin3D = $GobotSkin3D
@onready var _camera_3d: Camera3D = %Camera3D

func _init() -> void:
	input.load_player_inputs()

@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void:
	#region input
	var input_direction := Input.get_vector(input.move_left(), input.move_right(), input.move_up(), input.move_down())
	#endregion
	
	#region gravity
	if not is_on_floor():
		velocity += GRAVITY * delta
	#endregion
	
	#region ground movement
	var ground_direction := Vector3(input_direction.x, 0, input_direction.y)
	var desired_ground_velocity := ground_direction * max_speed
	var steering_vector := desired_ground_velocity - velocity
	var steering_amount: float = min(steering_factor * delta, 1.0)
	velocity += steering_vector * steering_amount
	#endregion
	
	#region rotation based on mouse position
	_ground_plane.d = global_position.y
	var mouse_position_2d := get_viewport().get_mouse_position()
	var mouse_ray := _camera_3d.project_ray_normal(mouse_position_2d)
	var world_mouse_position = _ground_plane.intersects_ray(_camera_3d.global_position, mouse_ray)
	if world_mouse_position:
		_skin.look_at(world_mouse_position)
	#endregion
	
	#region animation
	if is_on_floor() and ground_direction.length() > 0:
		_skin.run()
	else:
		_skin.idle()
	#endregion
	
	move_and_slide()
