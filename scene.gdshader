shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

bool is_border() {
	return true;
}

vec2 get_uv_at_px_offset(vec2 uv, vec2 offset) {
	return uv + (offset);
}

void fragment() {
	vec4 my_color = texture(screen_texture, SCREEN_UV);
	
	if (my_color.a < 0.99) {
		
	}
	
	COLOR = my_color;
	//COLOR = vec4(screen_color.a, screen_color.a, screen_color.a, 1.0);
}