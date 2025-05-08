shader_type canvas_item;

uniform bool hit_effect = false;
uniform vec3 hit_color : source_color = vec3(1.0, 1.0, 1.0);

void fragment() {
    vec4 color = texture(TEXTURE, UV);

    if (hit_effect) {
        vec4 effect_color = vec4(hit_color.r, hit_color.g, hit_color.b, color.a);
        color = mix(color, effect_color, effect_color.a);
    }

    if (UV.x < 0.0 || UV.x > 1.0 || UV.y < 0.0 || UV.y > 1.0) {
        discard;
    }

    COLOR = color;
}