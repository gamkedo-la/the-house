shader_type canvas_item;

uniform vec4 SkyTop : hint_color = vec4(0.878770, 0.899942, 0.717376, 1.000000);
uniform vec4 SkyBottom : hint_color = vec4(0.878770, 0.899942, 0.717376, 1.000000);
uniform vec4 MoonColor : hint_color = vec4(0.878770, 0.899942, 0.717376, 1.000000);
uniform vec3 MoonPos = vec3(0, .1, -.5);
uniform float MoonRadius : hint_range(0.0, 10.0, 0.1) = 5.;
uniform float MoonGlow : hint_range(0.0, 1.0, 0.01) = .1;
uniform vec2 TextureSize = vec2(1280., 720.);

vec3 rotate_y(vec3 v, float angle)
{
	float ca = cos(angle); float sa = sin(angle);
	return v*mat3(
		vec3(+ca, +.0, -sa),
		vec3(+.0,+1.0, +.0),
		vec3(+sa, +.0, +ca));
}

vec3 rotate_x(vec3 v, float angle)
{
	float ca = cos(angle); float sa = sin(angle);
	return v*mat3(
		vec3(+1.0, +.0, +.0),
		vec3(+.0, +ca, -sa),
		vec3(+.0, +sa, +ca));
}

void panorama_uv(vec2 fragCoord, out vec3 ro,out vec3 rd, in vec2 iResolution){
    float M_PI = 3.1415926535;
    float ymul = 2.0; float ydiff = -1.0;
    vec2 uv = fragCoord.xy / iResolution.xy;
    uv.x = 2.0 * uv.x - 1.0;
    uv.y = ymul * uv.y + ydiff;
    ro = vec3(0., 5., 0.);
	rd = rotate_x(vec3(0.0, 0.0, 1.0),-uv.y*M_PI/2.0);
	rd = rotate_y(rd,-uv.x*M_PI);
    rd = normalize(rd);
}

vec3 sky_color(vec3 uv) {
	vec3 moon_dir = normalize(vec3(0, abs(sin(.3)), -1));
	float moon_amount = max(dot(uv, moon_dir), 0.);
	
	vec3 c1 = vec3(.1, .1, .1);
	vec3 c2 = vec3(.1, .0, .3);
	float mixAmount = 1. - uv.y;
	vec3 sky = mix(SkyTop.rgb, SkyBottom.rgb, mixAmount);
	
	return sky;
}


void fragment(){
	vec3 ro = vec3(0.);
	vec3 rd = vec3(0.);
	panorama_uv(UV * TextureSize, ro, rd, TextureSize);

	vec3 sky = sky_color(rd);
	
	vec3 MoonDirection = normalize(MoonPos);
	float moon_amount = max(dot(rd, MoonDirection), 0.);
	vec3 moon = MoonColor.rgb * min(pow(moon_amount, 1500.) * MoonRadius, 1.)
		+ MoonColor.rgb * min(pow(moon_amount, 15.) * MoonGlow, 1.);
	
	COLOR.rgb = sky + moon;
}
