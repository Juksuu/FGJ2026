shader_type canvas_item;

global uniform vec4 mask_color;

uniform vec4 color = vec4(1, 1, 1, 0);

float max3(vec4 v) {
	return max(max(v.x, v.y), v.z);
}

void fragment() {
	vec4 c = texture(TEXTURE, UV);

	float mask_is_white = float(int(c.r) & int(c.g) & int(c.b) & int(c.a));

	vec4 combined_color = color + mask_color;
	combined_color.rgb /= max3(combined_color);

	vec4 applied_color = mix(c, combined_color, mask_is_white);

	COLOR = applied_color;
}
