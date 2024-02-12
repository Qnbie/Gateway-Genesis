shader_type spatial;

render_mode specular_toon;

uniform sampler2D noise;
uniform float amplitude = 1.0;

float height(vec2 position) {
	return texture(noise, position / 10.0).x * amplitude;
}

void vertex() {
	vec2 pos = VERTEX.xz;
	float k = height(pos);
	VERTEX.y = k;
	NORMAL = normalize(vec3(k - height(pos + vec2(0.1, 0.0)), 0.1, k - height(pos + vec2(0.0, 0.1))));
}

void fragment() {
	float fresnel = sqrt(1.0 - dot(NORMAL, VIEW));
	RIM = 0.2;
	METALLIC = 0.0;
	ROUGHNESS = 0.01;
	ALBEDO = vec3(0.1, 0.3, 0.5) + (0.1 * fresnel);
}