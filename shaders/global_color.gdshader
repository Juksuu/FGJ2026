shader_type canvas_item;

global uniform vec4 mask_color;

float max3(vec4 v) {
	return max(max(v.x, v.y), v.z);
}

void fragment() {
	vec4 c = texture(TEXTURE, UV);

	float is_white = float(all(equal(c, vec4(1))));
	vec4 applied_color = mix(c, mask_color, is_white);

	COLOR = applied_color;
}
