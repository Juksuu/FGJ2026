shader_type canvas_item;

uniform vec4 color = vec4(1, 1, 1, 0);

void fragment() {
	vec4 c = texture(TEXTURE, UV);
	float is_transparent = step(c.a, 0);

	vec3 applied_color = mix(c.rgb, color.rgb, is_transparent);
	float applied_alpha = mix(c.a, color.a, is_transparent);

	COLOR = vec4(applied_color, applied_alpha);
}
