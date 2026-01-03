shader_type spatial;
render_mode cull_disabled, unshaded;

uniform vec3 albedo : source_color;

void fragment() {
	float wave = (sin(UV.y * 10.0 * PI + TIME ) + 1.0) / 2.0;
	ALBEDO = albedo * 1.5;
	ALPHA = UV.y * max(0.5, step(wave, UV.y)) * max(0.5, float(FRONT_FACING));
}

