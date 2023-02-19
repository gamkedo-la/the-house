shader_type spatial;

uniform float AlphaScissor : hint_range(0.0, 1.0, 0.1) = 1.;
uniform sampler2D Albedo : hint_albedo;
uniform sampler2D Normal : hint_normal;
uniform float Animated : hint_range(0.0, 1.0, 1.0) = 1.0;
uniform sampler2D WindNoise : hint_black;
uniform float WindStrength : hint_range(0.0, 2.0, 0.01) = 0.2;
uniform float WindSpeed : hint_range(0.0, 10., 0.5) = 4.;
uniform float SwayStrength: hint_range(0.0, 1., 0.1) = 0.5;
uniform float SwayOffset;

void vertex() {
	if( Animated >= 0.0 )
	{
		float wind_speed = 10.1 - WindSpeed;
		float t = (TIME/wind_speed) + VERTEX.g;
		float height = texture(WindNoise, VERTEX.xz + t).r;
		VERTEX.y += height * VERTEX.r * WindStrength;
		
		float sway_strength = SwayStrength * 0.1;
		VERTEX.xz += sin(TIME + SwayOffset) * sway_strength * VERTEX.g;
	}
}

void fragment() {
	vec4 c = texture(Albedo, UV);
	vec4 n = texture(Normal, UV);
	
	NORMALMAP = n.rgb;
	ALPHA_SCISSOR = AlphaScissor;
	ALPHA = c.a;
	ALBEDO = c.rgb;
}
