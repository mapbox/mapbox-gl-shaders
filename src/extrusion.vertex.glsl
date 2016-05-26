#ifdef GL_ES
precision highp float;
#else
#define lowp
#define mediump
#define highp
#endif

attribute vec3 a_pos;
attribute vec3 a_normal;
uniform mat4 u_matrix;
uniform vec4 u_color;
uniform vec3 u_lightdir;
uniform vec4 u_shadow;
uniform lowp float u_opacity;
varying vec4 v_color;

void main() {
    gl_Position = u_matrix * vec4(a_pos, 1);

    v_color = u_color;

    // TODO better var names for these numbers
    float t = mod(a_normal.x, 2.0);
    float directional = clamp(dot(a_normal / 32768.0, u_lightdir), 0.0, 1.0);
    float shadow = clamp((0.3 - directional) / 7.0, 0.0, 0.3);
    directional = mix(0.7, 1.0, directional * 2.0 * (0.2 + t) / 1.2);

    v_color.rgb *= directional;
    v_color *= u_opacity;
    v_color += shadow * u_shadow;
}

