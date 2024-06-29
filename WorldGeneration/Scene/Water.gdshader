shader_type spatial;
render_mode unshaded,cull_disabled;

uniform vec3 color:source_color = vec3(0.0,0.5,1.0);
uniform float wave_speed : hint_range(0.0, 0.2) = 0.015;
varying float wave_height;
uniform sampler2D wave_texture;
uniform float wave_scale = 4.0;
uniform float height_scale = 8.0;

void vertex() {
	// Vertext displacement for waves
	vec3 uv_world_pos = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
	wave_height = texture(wave_texture, uv_world_pos.xz / 512.0 + TIME * wave_speed).r;
	VERTEX.y += wave_height * height_scale;
	COLOR.xyz = vec3((VERTEX.y + 2.0 * height_scale)/(height_scale*2.0)) * color;
	
}

void fragment() {
	// Place fragment code here.
	ALBEDO = COLOR.xyz;
	ALPHA = 0.9;
}
