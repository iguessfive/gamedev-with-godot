class_name FpsArmsSkin
extends Node3D
## Controls the visuals and animations of the player's arms in our FPS character controller.
##
## This class allows you to play the FPS arm animations (like walking, shooting,
## reloading) and makes the arms move smoothly when the player moves around. It
## can also handle visual effects like blinking when the player takes damage.

enum States { IDLE, WALK }

var state := States.IDLE:
	set = _set_state

var _state_map := {
	States.IDLE: "Idle",
	States.WALK: "Walk",
}
var _plane_velocity := Vector2.ZERO
var _angle_velocity := Vector3.ZERO
var _vertical_velocity := 0.0

## The position where bullets come from when the player shoots.
## Other scripts can use this marker to know where to spawn bullets (or check
## what the gun is pointing at).
@onready var fire_marker: Marker3D = %FireMarker

@onready var _parent: Node3D = get_parent() as Node3D
@onready var _parent_previous_transform: Transform3D = _parent.global_transform
@onready var _animation_tree: AnimationTree = %AnimationTree
@onready var _state_machine: AnimationNodeStateMachinePlayback = _animation_tree.get("parameters/StateMachine/playback")
@onready var _foot_step_audio: AudioStreamPlayer = %FootStepAudio
@onready var _jump_audio: AudioStreamPlayer = %JumpAudio
@onready var _fire_audio: AudioStreamPlayer = %FireAudio
@onready var _arms: MeshInstance3D = $GLBModel/Rig/Skeleton3D/arms


func _process(delta: float) -> void:
	_apply_rotation_effect(delta)


## Plays the shooting animation and sound effect.
func fire() -> void:
	_animation_tree.set("parameters/FireOneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	_fire_audio.play()


## Checks if the reload animation is currently playing and returns true if
## reloading, false otherwise.
func is_reloading() -> bool:
	return _animation_tree.get("parameters/ReloadOneShot/active")


## Plays the reload animation.
func reload() -> void:
	_animation_tree.set("parameters/ReloadOneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)


## Checks if the shake animation is currently playing and returns true if
## shaking, false if not shaking.
func is_shaking() -> bool:
	return _animation_tree.get("parameters/ShakeOneShot/active")


## Plays a shake animation on the arms. You can use this to indicate that the
## player is out of ammo or cannot interact with something.
func shake() -> void:
	_animation_tree.set("parameters/ShakeOneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)


## Changes how fast the walking animation plays and how loud the footsteps are.
## The walk_speed is clamped between 0.5 (slow) and 2.0 (fast). The loudness
## should be between 0.0 and 1.0.
func set_walk_speed(walk_speed: float, loudness := 1.0) -> void:
	walk_speed = clamp(walk_speed, 0.5, 2.0)
	_foot_step_audio.volume_linear = loudness
	_animation_tree.set("parameters/StateMachine/Walk/WalkSpeed/scale", walk_speed)


## Makes the arms flash briefly with a color. Use this to show the character
## taking damage or gaining health or a shield.
func blink(color: Color = Color.LIME_GREEN) -> void:
	var blink_material: StandardMaterial3D = _arms.material_overlay
	blink_material.albedo_color = color
	blink_material.emission = color

	var tween: Tween = create_tween()
	tween.tween_property(blink_material, "emission_energy_multiplier", 1.0, 0.25).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween.parallel().tween_property(blink_material, "albedo_color:a", 0.4, 0.25).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween.tween_property(blink_material, "emission_energy_multiplier", 0.0, 0.25).set_ease(Tween.EASE_IN)
	tween.parallel().tween_property(blink_material, "albedo_color:a", 0.0, 0.25).set_ease(Tween.EASE_IN)


func _set_state(value: States) -> void:
	if value == state:
		return
	state = value
	_state_machine.travel(_state_map[state])


func _on_footstep() -> void:
	_foot_step_audio.play()


func _on_jump(weight: float) -> void:
	if weight < 0.1:
		return
	_jump_audio.volume_linear = clamp(weight, 0.2, 1.0)
	_jump_audio.pitch_scale = randfn(1.0, 0.1)
	_jump_audio.play()


func _apply_rotation_effect(delta: float) -> void:
	var parent_current_transform := _parent.global_transform
	var plane_difference := _get_transform_plane(parent_current_transform) - _get_transform_plane(_parent_previous_transform)
	plane_difference = plane_difference.rotated(_parent.rotation.y)

	var angle_change := (parent_current_transform.basis * _parent_previous_transform.basis.inverse()).get_euler()

	var vertical_difference := parent_current_transform.origin.y - _parent_previous_transform.origin.y

	_plane_velocity += plane_difference * 10.0 * delta
	_plane_velocity = _plane_velocity.lerp(Vector2.ZERO, 10.0 * delta)

	_vertical_velocity += vertical_difference * 10.0 * delta
	_vertical_velocity = lerp(_vertical_velocity, 0.0, 10.0 * delta)

	_angle_velocity += angle_change * 10.0 * delta
	_angle_velocity = _angle_velocity.slerp(Vector3.ZERO, 10.0 * delta)

	rotation.y = _plane_velocity.x - _angle_velocity.y
	rotation.x = _plane_velocity.y - _vertical_velocity - _angle_velocity.x

	_parent_previous_transform = parent_current_transform


func _get_transform_plane(p_transform: Transform3D) -> Vector2:
	return Vector2(p_transform.origin.x, p_transform.origin.z)
