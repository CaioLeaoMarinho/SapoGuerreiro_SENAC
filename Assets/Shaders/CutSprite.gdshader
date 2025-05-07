shader_type canvas_item;

// Controles principais
uniform float cut_progress : hint_range(0, 1) = 0.0;
uniform float cut_vertical_progress : hint_range(0, 1) = 0.0;
uniform float cut_position : hint_range(0, 1) = 0.5;
uniform float separation_force : hint_range(0, 0.5) = 0.0;

uniform bool hit_effect = false;
uniform vec3 hit_color : source_color = vec3(1.0, 1.0, 1.0);

void fragment() {
    vec2 uv = UV;
    float center_x = cut_position;
    float vertical_cut = cut_vertical_progress;

    if (uv.y <= vertical_cut) {

        bool is_left = uv.x < center_x;

        if (is_left) {
            uv.x += cut_progress * separation_force;

            if (uv.x > center_x) discard;
        } else {
            uv.x -= cut_progress * separation_force;

            if (uv.x < center_x) discard;
        }
    }

    vec4 color = texture(TEXTURE, uv);

    if (hit_effect) {
        vec4 effect_color = vec4(hit_color.r, hit_color.g, hit_color.b, color.a);
        color = mix(color, effect_color, effect_color.a);
    }

    if (uv.x < 0.0 || uv.x > 1.0 || uv.y < 0.0 || uv.y > 1.0) {
        discard;
    }

    COLOR = color;
}