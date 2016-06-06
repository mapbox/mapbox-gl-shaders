#ifdef GL_ES
precision highp float;
#else
#define lowp
#define mediump
#define highp
#endif

uniform mat4 u_matrix;
attribute vec2 a_pos;
// #ifdef MAPBOX_GL_JS
// attribute vec2 a_texture_pos;
// #endif

// #ifndef MAPBOX_GL_JS
varying vec2 v_pos;
uniform float u_xdim;
uniform float u_ydim;

// #else
// varying vec2 v_pos0;
// varying vec2 v_pos1;
// #endif

void main() {
    gl_Position = u_matrix * vec4(a_pos, 0, 1);
// #ifndef MAPBOX_GL_JS
    // float dimension = (8192.0 + 2.0 * u_buffer);
    // float dimension = 8192.0;


    // v_pos = a_pos / dimension;
    // v_pos = a_pos / 8192.0; {}
    v_pos.x = a_pos.x / u_xdim;
    v_pos.y = 1.0 - a_pos.y / u_ydim;


// #else
//     v_pos0 = (((a_texture_pos / 32767.0) - 0.5) / u_buffer_scale ) + 0.5;
//     v_pos1 = (v_pos0 * u_scale_parent) + u_tl_parent;
// #endif
}
