shader_type canvas_item;

uniform vec4 line_color : source_color = vec4(1);
uniform float line_thickness : hint_range(0, 10) = 1.0;
uniform bool enable_outline = false;

void fragment() {
	if (!enable_outline)
	{
		vec4 sprite_color = texture(TEXTURE, UV);
		COLOR = sprite_color;
	}
	else
	{
	vec2 size = TEXTURE_PIXEL_SIZE * line_thickness;

	float outline = texture(TEXTURE, UV + vec2(-size.x, 0)).a;
	outline += texture(TEXTURE, UV + vec2(0, size.y)).a;

	outline += texture(TEXTURE, UV + vec2(size.x, 0)).a;

	outline += texture(TEXTURE, UV + vec2(0, -size.y)).a;


	outline += texture(TEXTURE, UV + vec2(-size.x, size.y)).a;

	outline += texture(TEXTURE, UV + vec2(-size.x, size.y * 0.5)).a;



	outline += texture(TEXTURE, UV + vec2(size.x, size.y)).a;
	outline += texture(TEXTURE, UV + vec2(size.x, size.y * 0.5)).a;


	outline += texture(TEXTURE, UV + vec2(-size.x, -size.y)).a;
	outline += texture(TEXTURE, UV + vec2(-size.x, -size.y * 0.5)).a;



	outline += texture(TEXTURE, UV + vec2(size.x, -size.y)).a;
	outline += texture(TEXTURE, UV + vec2(size.x, -size.y * 0.5)).a;


	outline = min(outline, 1.0);


	vec4 color = texture(TEXTURE, UV);
	COLOR = mix(color, line_color, outline - color.a);
	}
}