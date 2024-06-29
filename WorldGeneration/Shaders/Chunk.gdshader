shader_type spatial;

uniform float verticess[66049];
uniform vec3 tx[66049];
uniform vec3 ty[66049];
uniform vec2 pos;
uniform vec3 color : source_color;
uniform float maxh : hint_range(0.0, 1024.0, 4.0) = 16.0;

uniform float size = 16.0;
uniform float siz = -1.0;
global uniform vec3 player_pos;
varying vec3 world_vertex;


uniform sampler2D noise: source_color;

uniform sampler2D grass_texture: source_color;
uniform sampler2D rock_texture: source_color;
uniform sampler2D sand_texture: source_color;

uniform sampler2D grass_normal_texture: source_color;
uniform sampler2D rock_normal_texture: source_color;
uniform sampler2D sand_normal_texture: source_color;

uniform float min_rock_slope:hint_range(0.0,1.0,0.01) = 0.5;
uniform float max_grass_slope:hint_range(0.0,1.0,0.01) = 0.9;
uniform float min_rockgrass_height = -0.8;
uniform float max_sand_height = -0.8;

varying float normal_y;
varying float vertex_y;


void vertex() {
	world_vertex = (MODEL_MATRIX * vec4(VERTEX,1.0)).xyz;
	
	VERTEX.y = verticess[VERTEX_ID];
	NORMAL = cross(ty[VERTEX_ID],tx[VERTEX_ID]);
	
	normal_y = NORMAL.y;
	vertex_y = VERTEX.y;
	//COLOR = texture(grass_texture,UV*4.0).rgba;
}

void fragment() {
	float distans = min(length( vec2(player_pos.x,player_pos.z) - vec2(world_vertex.x,world_vertex.z)),size);
	float distanc = max(length( vec2(player_pos.x,player_pos.z) - vec2(world_vertex.x,world_vertex.z)),siz);
	ALPHA = clamp((size - distans)*(distanc - siz),0.0,1.0);
	ALPHA_SCISSOR_THRESHOLD = 0.4;
	
	//Albedo Values
	vec3 grass_albedo = mix(texture(grass_texture,UV*1.0).xyz,texture(grass_texture,UV*8.0).xyz,5.0);
	vec3 rock_albedo = texture(rock_texture,UV*16.0).xyz;
	vec3 sand_albedo = mix(texture(sand_texture,UV.yx*16.0).xyz,texture(sand_texture,UV*16.0).xyz,texture(noise,UV).r);
	
	vec3 grass_normal = texture(grass_normal_texture,UV*8.0).xyz;
	vec3 rock_normal = texture(rock_normal_texture,UV*2.0).xyz;
	vec3 sand_normal = mix(texture(sand_normal_texture,UV.yx*16.0).xyz,texture(sand_normal_texture,UV*16.0).xyz,texture(noise,UV).r);
	//Weights
	float rock_grass_weight = normal_y;
	float sand_rockgrass_weight = vertex_y;
	//Calculating Rock/Grass Weight
	rock_grass_weight = max(min_rock_slope, rock_grass_weight);
	rock_grass_weight = min(max_grass_slope, rock_grass_weight);
	rock_grass_weight -= min_rock_slope;
	rock_grass_weight /= max_grass_slope - min_rock_slope;
	//Calculating Sand/RockGrass Weight
	sand_rockgrass_weight = max(min_rockgrass_height, sand_rockgrass_weight);
	sand_rockgrass_weight = min(max_sand_height, sand_rockgrass_weight);
	sand_rockgrass_weight -= min_rockgrass_height;
	sand_rockgrass_weight /= max_sand_height - min_rockgrass_height;
	//Mixing and Assigning Albedo
	vec3 rockgrass_albedo = mix(rock_albedo, grass_albedo, rock_grass_weight);
	vec3 rockgrass_normal = mix(rock_normal, grass_normal, rock_grass_weight);
	
	ALBEDO = mix(sand_albedo, rockgrass_albedo, sand_rockgrass_weight);
	NORMAL_MAP = mix(sand_normal, rockgrass_normal, sand_rockgrass_weight);
	
}
