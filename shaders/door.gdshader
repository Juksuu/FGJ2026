shader_type canvas_item;

global uniform vec4 mask_color;

uniform vec2 sheet_size;
uniform vec2 sheet_start;
uniform vec2 mask_size;

instance uniform vec4 color = vec4(1, 1, 1, 0);

uniform sampler2D mask_texture : hint_default_transparent;


float max3(vec4 v) {
	return max(max(v.x, v.y), v.z);
}

void fragment() {
	vec4 c = texture(TEXTURE, UV);
	float is_transparent = step(c.a, 0);

	float global_mask_color_is_white = float(all(equal(mask_color.rgb, vec3(1))));

	vec4 combined_color = color + (mask_color * (1.0 - vec4(global_mask_color_is_white)));
	combined_color.rgb /= max3(combined_color);

	float mask_is_color = float(all(equal(color.rgb, mask_color.rgb)));

	vec3 applied_color = mix(c.rgb, combined_color.rgb, is_transparent);
	float applied_alpha = mix(c.a, combined_color.a * (1.0 - mask_is_color), is_transparent);

	vec2 mask_uv = vec2(((UV.x * sheet_size.x) - sheet_start.x) / mask_size.x, ((UV.y * sheet_size.y) - sheet_start.y) / mask_size.y);

	vec4 mc = texture(mask_texture, mask_uv);
	int mask_combined_alpha = 1 - (int(c.a) & int(mc.a));

	COLOR = vec4(applied_color, applied_alpha * float(mask_combined_alpha));
}
