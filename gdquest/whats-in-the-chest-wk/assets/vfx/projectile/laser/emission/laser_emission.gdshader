shader_type spatial;
render_mode depth_draw_opaque, unshaded;

uniform float intensity = 1.0;
uniform vec3 edge_color : source_color;
uniform vec3 core_color : source_color;
uniform sampler2D mask_sampler : repeat_disable, filter_linear;


void vertex() {
	// Billboard Mode: Enabled
	MODELVIEW_MATRIX = VIEW_MATRIX * mat4(
			MAIN_CAM_INV_VIEW_MATRIX[0],
			MAIN_CAM_INV_VIEW_MATRIX[1],
			MAIN_CAM_INV_VIEW_MATRIX[2],
			MODEL_MATRIX[3]);

	// Billboard Keep Scale: Enabled
	MODELVIEW_MATRIX = MODELVIEW_MATRIX * mat4(
			vec4(length(MODEL_MATRIX[0].xyz), 0.0, 0.0, 0.0),
			vec4(0.0, length(MODEL_MATRIX[1].xyz), 0.0, 0.0),
			vec4(0.0, 0.0, length(MODEL_MATRIX[2].xyz), 0.0),
			vec4(0.0, 0.0, 0.0, 1.0));
	MODELVIEW_NORMAL_MATRIX = mat3(MODELVIEW_MATRIX);
}

void fragment() {
	vec2 mask = texture(mask_sampler, UV).rg;
	ALBEDO = mix(edge_color, core_color, mask.r) * intensity;
	ALPHA *= mask.g;
}