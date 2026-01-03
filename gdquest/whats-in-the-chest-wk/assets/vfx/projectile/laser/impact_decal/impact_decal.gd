extends Decal
## A decal that shows impact marks on surfaces with randomized textures.

@export var diffuse: Array[Texture] = []
@export var normal: Array[Texture] = []


func _ready() -> void:
	var picked_texture_id := randi_range(0, diffuse.size() - 1)
	texture_albedo = diffuse[picked_texture_id]
	texture_normal = normal[picked_texture_id]


func fade_out() -> void:
	var fade_tween := create_tween()
	fade_tween.tween_property(self, "modulate:a", 0.0, 1.0)
	fade_tween.tween_callback(queue_free)
