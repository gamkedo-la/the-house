shader_type spatial;
render_mode cull_disabled;

uniform sampler2D color_ramp : hint_black_albedo;
uniform sampler2D grass_tex;

void fragment() {
//	vec3 colour = texture(color_ramp, vec2(1.0 - UV.y, 0)).rgb;
	vec3 colour = texture(color_ramp, UV).rgb;
	float alpha = texture(grass_tex, UV).a;
	ALBEDO = colour;
	ALPHA = alpha;
}