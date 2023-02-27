shader_type spatial;
render_mode cull_disabled;

uniform sampler2D dirt_albedo : hint_white;
uniform sampler2D dirt_normal : hint_normal;
uniform sampler2D grass_albedo : hint_black_albedo;
uniform sampler2D grass_normal : hint_normal;

/* R = dirt */
uniform sampler2D color_map : hint_black_albedo;

uniform float uv_scale : hint_range(0.0, 50.0, 0.1);

uniform float normal_strength : hint_range(0.0, 5.0, 0.1);
uniform float roughness : hint_range(0.0, 1.0, 0.01);
uniform float specular : hint_range(0.0, 1.0, 0.01);

varying vec3 WORLD_POSITION;

void vertex() {
	WORLD_POSITION = (WORLD_MATRIX * vec4(VERTEX, 1.0)).xyz;
}

vec3 blend_normal(vec3 A, vec3 B) {
	return normalize(vec3(A.rg + B.rg, A.b * B.b));
}

void fragment() {
	vec4 vert_color = texture(color_map, UV);
	vec2 world_uv = vec2(WORLD_POSITION.x, WORLD_POSITION.z) * uv_scale;
	
	vec3 grass_color = texture(grass_albedo, world_uv).rgb;
	vec3 dirt_color = texture(dirt_albedo, world_uv).rgb;
	ALBEDO = mix(grass_color, dirt_color, vert_color.r);
	
	vec3 grass_bump = texture(grass_normal, world_uv).rgb;
	vec3 dirt_bump = texture(dirt_normal, world_uv).rgb;
	NORMALMAP = mix(grass_bump, dirt_bump, vert_color.r);
	NORMALMAP_DEPTH = normal_strength;
	
	ROUGHNESS = roughness;
	SPECULAR = specular;
}