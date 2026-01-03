shader_type spatial;
render_mode depth_draw_opaque, unshaded, cull_disabled;

uniform float intensity = 1.0;
uniform vec3 edge_color : source_color;
uniform vec3 core_color : source_color;
uniform sampler2D mask_sampler : repeat_disable, filter_linear;

void fragment() {
	vec3 mask = texture(mask_sampler, UV).rgb;
	ALBEDO = mix(edge_color, core_color, mask.r) * intensity;
	ALPHA = mask.b * COLOR.a;
}