#ifdef GL_ES
precision highp float;
#else
#define lowp
#define mediump
#define highp
#endif

uniform mat4 u_matrix;
uniform vec2 u_pattern_size_a;
uniform vec2 u_pattern_size_b;
uniform vec2 u_pixel_coord_upper;
uniform vec2 u_pixel_coord_lower;
uniform float u_scale_a;
uniform float u_scale_b;
uniform float u_tile_units_to_pixels;

uniform vec3 u_lightdir;
uniform vec4 u_shadow;

attribute vec3 a_pos;
attribute vec3 a_normal;
attribute float a_edgedistance;

varying vec2 v_pos_a;
varying vec2 v_pos_b;
varying vec4 v_shadow;
varying float v_directional;

void main() {
    gl_Position = u_matrix * vec4(a_pos, 1);

    vec3 sth = a_pos;

    vec2 scaled_size_a = u_scale_a * u_pattern_size_a;
    vec2 scaled_size_b = u_scale_b * u_pattern_size_b;

    // the following offset calculation is duplicated from the regular pattern shader:
    vec2 offset_a = mod(mod(mod(u_pixel_coord_upper, scaled_size_a) * 256.0, scaled_size_a) * 256.0 + u_pixel_coord_lower, scaled_size_a);
    vec2 offset_b = mod(mod(mod(u_pixel_coord_upper, scaled_size_b) * 256.0, scaled_size_b) * 256.0 + u_pixel_coord_lower, scaled_size_b);

    if (a_normal[0] == 1.0 && a_normal[1] == 0.0 && a_normal[2] == 16384.0) {
        v_pos_a = (u_tile_units_to_pixels * vec2(a_pos[0], a_pos[1]) + offset_a) / scaled_size_a;
        v_pos_b = (u_tile_units_to_pixels * vec2(a_pos[0], a_pos[1]) + offset_b) / scaled_size_b;
    } else {
        float hf = a_pos[2] * -8.0;

        v_pos_a = (u_tile_units_to_pixels * vec2(a_edgedistance, hf) + offset_a) / scaled_size_a;
        v_pos_b = (u_tile_units_to_pixels * vec2(a_edgedistance, hf) + offset_b) / scaled_size_b;
    }

    float t = mod(a_normal.x, 2.0);
    float directional = clamp(dot(a_normal / 32768.0, u_lightdir), 0.0, 1.0);
    float shadow = clamp((0.3 - directional) / 7.0, 0.0, 0.3);
    directional = mix(0.7, 1.0, directional * 2.0 * (0.2 + t) / 1.2);

    v_shadow = shadow * u_shadow;
    v_directional = directional;
}
