class_name ProjectileRayCast
extends RayCast3D

## This class represents the projectile's continuous collision detection. It's a
## raycast that moves through the world from the player camera and detects hits
## with objects.

## How fast the projectile travels through the world in meters per second.
@export var speed := 30.0
## The maximum distance the projectile can travel before disappearing.
@export var max_range := 100.0

## The projectile's current velocity. This is set when the projectile is fired.
var velocity := Vector3.ZERO
## How far the projectile has traveled since it was fired.
var _distance_traveled := 0.0

func _ready() -> void:
	collide_with_areas = true
	collide_with_bodies = true
	collision_mask = 0b1001
	enabled = false

func setup(player_camera: Camera3D) -> void:
	global_position = player_camera.global_position
	velocity = -1.0 * player_camera.global_basis.z * speed

func _physics_process(delta: float) -> void:
	var movement := velocity * delta
	target_position = movement
	
	force_raycast_update()
	if is_colliding():
		var collider: Object = get_collider()
		var collision_position := get_collision_point()
		if collider is HurtBox3D:
			collider.take_hit(collision_position)
		queue_free()
	
	global_position += movement
	_distance_traveled += movement.length()
	if _distance_traveled >= max_range:
		queue_free()
	
