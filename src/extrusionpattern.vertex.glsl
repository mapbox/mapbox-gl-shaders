#ifdef GL_ES
precision highp float;
#else
#define lowp
#define mediump
#define highp
#endif

#ifndef MAPBOX_GL_JS
uniform mat4 u_matrix;
uniform vec2 u_patternscale_a;
uniform vec2 u_patternscale_b;
uniform vec2 u_offset_a;
uniform vec2 u_offset_b;
#else
uniform mat4 u_matrix;
uniform vec2 u_pattern_size_a;
uniform vec2 u_pattern_size_b;
uniform vec2 u_pixel_coord_upper;
uniform vec2 u_pixel_coord_lower;
uniform float u_scale_a;
uniform float u_scale_b;
uniform float u_tile_units_to_pixels;
uniform vec3 u_patternmatrix_a;
uniform vec3 u_patternmatrix_b;
#endif

attribute vec3 a_pos;
attribute vec3 a_normal;

varying vec2 v_pos_a;
varying vec2 v_pos_b;

void main() {
    gl_Position = u_matrix * vec4(a_pos, 1);

#ifndef MAPBOX_GL_JS
    v_pos_a = u_patternscale_a * a_pos + u_offset_a;
    v_pos_b = u_patternscale_b * a_pos + u_offset_b;
#else
    vec2 scaled_size_a = u_scale_a * u_pattern_size_a;         // TODO note to self: if you multiply
    vec2 scaled_size_b = u_scale_b * u_pattern_size_b;         // these by -1.0 they flip upside down

    // the correct offset needs to be calculated.
    //
    // The offset depends on how many pixels are between the world origin and
    // the edge of the tile:8
    // vec2 offset = mod(pixel_coord, size)
    //
    // At high zoom levels there are a ton of pixels between the world origin
    // and the edge of the tile. The glsl spec only guarantees 16 bits of
    // precision for highp floats. We need more than that.
    //
    // The pixel_coord is passed in as two 16 bit values:
    // pixel_coord_upper = floor(pixel_coord / 2^16)
    // pixel_coord_lower = mod(pixel_coord, 2^16)
    //
    // The offset is calculated in a series of steps that should preserve this precision:
    vec2 offset_a = mod(mod(mod(u_pixel_coord_upper, scaled_size_a) * 256.0, scaled_size_a) * 256.0 + u_pixel_coord_lower, scaled_size_a);
    vec2 offset_b = mod(mod(mod(u_pixel_coord_upper, scaled_size_b) * 256.0, scaled_size_b) * 256.0 + u_pixel_coord_lower, scaled_size_b);

    v_pos_a = (u_tile_units_to_pixels * vec2(a_pos[0], a_pos[1]) + offset_a) / scaled_size_a;
    v_pos_b = (u_tile_units_to_pixels * vec2(a_pos[0], a_pos[1]) + offset_b) / scaled_size_b;
#endif
}
