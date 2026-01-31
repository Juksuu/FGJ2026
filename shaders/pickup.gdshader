shader_type canvas_item;

uniform vec4 color = vec4(1, 1, 1, 0);

void fragment() {
	vec4 c = texture(TEXTURE, UV);

	float mask_is_white = float(int(c.r) & int(c.g) & int(c.b) & int(c.a));
	
	vec4 applied_color = mix(c, color, mask_is_white);

	COLOR = applied_color;
}
