## Individual bullet icon for the ammo counter display.
extends Panel

var _tween: Tween = null

@onready var style_box: StyleBoxFlat = get("theme_override_styles/panel")
@onready var base_color: Color = style_box.bg_color


func set_color(color: Color, duration: float = 1.0, delay: float = 0.0) -> void:
	if _tween:
		_tween.kill()

	base_color = color
	_tween = create_tween()
	_tween.tween_property(style_box, "bg_color", color, duration).set_delay(delay)


func blink(blink_color: Color):
	if _tween:
		_tween.kill()

	_tween = create_tween()
	_tween.tween_property(style_box, "bg_color", blink_color, 0.2).set_ease(Tween.EASE_OUT)
	_tween.tween_property(style_box, "bg_color", base_color, 0.1).set_ease(Tween.EASE_IN).set_delay(0.1)
