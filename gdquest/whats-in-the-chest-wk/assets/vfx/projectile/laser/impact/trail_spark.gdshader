shader_type spatial;
render_mode unshaded;
varying vec4 custom;

void vertex(){
	custom = INSTANCE_CUSTOM;
}

void fragment() {
	float edge = sin(UV.x * PI) * sin(UV.y * PI);
	edge = step(custom.z, edge);
	ALBEDO = COLOR.rgb;
	ALPHA = edge * (1.0 - custom.x);
}
