shader_type spatial;
render_mode unshaded;

const int pixel_size = 4;
uniform sampler2D screen_texture : source_color, hint_screen_texture, filter_nearest;
void fragment() {
	float x = float(int(FRAGCOORD.x) % pixel_size);
	float y = float(int(FRAGCOORD.y) % pixel_size);
	
	x = FRAGCOORD.x + floor(float(pixel_size) / 2.0) - x;
	y = FRAGCOORD.y + floor(float(pixel_size) / 2.0) - y;

	ALBEDO = texture(screen_texture,vec2(x,y) / VIEWPORT_SIZE).xyz;
	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
