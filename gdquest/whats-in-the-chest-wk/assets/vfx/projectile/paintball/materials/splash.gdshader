shader_type spatial;
render_mode cull_disabled;

uniform sampler2D splash_sampler : filter_linear_mipmap, repeat_enable;
uniform vec3 albedo : source_color;
uniform float dissolve = 0.0;
uniform float uv_offset = 0.0;
uniform vec2 uv_scale = vec2(1.0, 1.0);

void fragment() {
	float x = texture(splash_sampler, (UV * uv_scale) + vec2(0.0, uv_offset)).x;
	float y = texture(splash_sampler, (UV * uv_scale)).y;
	ALBEDO = albedo;
	ROUGHNESS = 0.4;
	SPECULAR = 0.8;
	ALPHA = step(dissolve, x * y);
	ALPHA_SCISSOR_THRESHOLD = 0.5;
}
