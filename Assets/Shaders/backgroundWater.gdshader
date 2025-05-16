shader_type canvas_item;

uniform vec2 wave_speed = vec2(0.5, 0.2);
uniform float distorcion : hint_range(0.0, 1.0) = 0.01;
uniform sampler2D screen_texture : hint_screen_texture;
uniform sampler2D noise_texture : filter_nearest, repeat_enable;

void fragment()
{
	vec2 uv = UV + wave_speed * TIME;
	
	vec2 noise = 2.0 * texture(noise_texture, uv).rg - vec2(1.0);
	
	COLOR = texture(TEXTURE, UV);
	
	COLOR *= texture(screen_texture, SCREEN_UV + noise * distorcion);
}