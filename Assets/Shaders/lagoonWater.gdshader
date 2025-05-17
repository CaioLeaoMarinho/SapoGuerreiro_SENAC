shader_type canvas_item;

uniform vec4 water_color : source_color;
uniform float water_fade : hint_range(0.0, 1.0) = 1.0;
uniform float reflection_amount : hint_range(0.0, 1.0) = 0.0;
uniform float reflection_opacity : hint_range(0.0, 1.0) = 0.7;
uniform float wave_speed : hint_range(0.0, 1.0) = 0.02;
uniform float stretch_intensity : hint_range(0.0, 2.0) = 0.5; // Controla o quanto estica para os lados
uniform sampler2D screen_texture : hint_screen_texture;
uniform sampler2D wave_noise : repeat_enable;

void fragment() {
    vec2 water_wave = (texture(wave_noise, UV + TIME * wave_speed).rg - -0.75) * 0.01;

    // Invertemos UV.y para que o efeito comece em baixo: (1.0 - UV.y)
    float stretch_factor = (1.0 - UV.y) * stretch_intensity;

    // Aplica o esticamento progressivo nos lados (mais intenso no topo)
    vec2 stretched_uv = SCREEN_UV;
    stretched_uv.x = stretch_factor * (SCREEN_UV.x - 0.5) + 0.5; // Centraliza o esticamento

    // Combina com a reflexão normal
    vec2 uv = vec2(
    stretched_uv.x + water_wave.x * (.0 + (1.0 - UV.y)),
    SCREEN_UV.y - (UV.y + reflection_amount) + water_wave.y
);

    vec4 color = texture(screen_texture, uv);

    float mix_value = water_fade - UV.y;
    float avg_color = (color.r + color.g + color.b) / 3.0;
    avg_color = pow(avg_color, 1.4);
    mix_value += avg_color;

    mix_value = clamp(mix_value, 0.0, reflection_opacity);
    COLOR = mix(water_color, color, mix_value);
}