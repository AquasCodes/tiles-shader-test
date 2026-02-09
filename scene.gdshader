shader_type canvas_item;

const vec2 offsets[6] = {
	vec2(-1, 0),
	vec2(1, 0),
	vec2(0, 1),
	vec2(0, -2),
	vec2(-1, -1),
	vec2(1, -1)};

uniform vec4 outline_col : source_color;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

vec2 get_uv_at_px_offset(vec2 uv, vec2 offset, vec2 px_size) {
	return uv + vec2(px_size.x * offset.x, px_size.y * offset.y);
}

bool is_border(vec2 s_uv, vec2 px_size) {
	for (int i = 0; i < 6; i++) {
		vec2 off_uv = get_uv_at_px_offset(s_uv, offsets[i], px_size);
		vec4 off_col = texture(screen_texture, off_uv);
		if (off_col.a > 0.01) {
			return true;
		}
	}
	
	return false;
}

void fragment() {
	vec4 my_color = texture(screen_texture, SCREEN_UV);
	
	if (my_color.a < 0.99) {
		if (is_border(SCREEN_UV, SCREEN_PIXEL_SIZE)) {
			my_color = outline_col;
		}
	}
	
	COLOR = my_color;
	//COLOR = vec4(screen_color.a, screen_color.a, screen_color.a, 1.0);
}