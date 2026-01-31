shader_type canvas_item;

uniform vec4 color = vec4(1, 1, 1, 0);

uniform sampler2D mask_texture : hint_default_transparent;

void fragment() {
	vec4 c = texture(TEXTURE, UV);
	float is_transparent = step(c.a, 0);

	vec3 applied_color = mix(c.rgb, color.rgb, is_transparent);
	float applied_alpha = mix(c.a, color.a, is_transparent);

	vec4 mc = texture(mask_texture, UV);
	int mask_combined_alpha = 1 - (int(c.a) & int(mc.a));

	COLOR = vec4(applied_color, applied_alpha * float(mask_combined_alpha));
}
