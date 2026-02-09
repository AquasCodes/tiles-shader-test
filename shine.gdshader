shader_type canvas_item;

uniform float spacing : hint_range(0, 1000, 1);
uniform float max_dist : hint_range(0, 0.5, 0.01);
uniform float speed;

void fragment() {
	float diag_pos = FRAGCOORD.x + FRAGCOORD.y - (TIME * speed);
	float along = mod(diag_pos, spacing) / spacing;
	float dist_mid = abs(along - 0.5);
	if (dist_mid < max_dist) {COLOR = vec4(1.0, 1.0, 1.0, COLOR.a);}
}