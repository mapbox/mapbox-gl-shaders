#ifdef GL_ES
precision highp float;
#else
#define lowp
#define mediump
#define highp
#endif

attribute vec2 a_pos;
attribute float a_isUpper;
attribute vec3 a_normal;
attribute float a_edgedistance;
uniform mat4 u_matrix;
uniform vec3 u_lightdir;
uniform vec4 u_shadow;
varying vec4 v_color;

#ifndef MAPBOX_GL_JS
attribute float a_minH;
attribute float a_maxH;
#else
#pragma mapbox: define lowp float minH
#pragma mapbox: define lowp float maxH
#endif

#pragma mapbox: define lowp vec4 color
#pragma mapbox: define highp float opacity

void main() {
#ifdef MAPBOX_GL_JS
    #pragma mapbox: initialize lowp float minH
    #pragma mapbox: initialize lowp float maxH
#endif
    #pragma mapbox: initialize lowp vec4 color
    #pragma mapbox: initialize highp float opacity

    float ed = a_edgedistance; // this is dumb, but we have to use each attrib in order to not trip a VAO assert

#ifdef MAPBOX_GL_JS
    gl_Position = u_matrix * vec4(a_pos, a_isUpper > 0.0 ? maxH : minH, 1);
#else
    gl_Position = u_matrix * vec4(a_pos, a_isUpper > 0.0 ? a_maxH : a_minH, 1);
#endif

    v_color = color;

    float t = mod(a_normal.x, 2.0);
    float directional = clamp(dot(a_normal / 32768.0, u_lightdir), 0.0, 1.0);
    float shadow = clamp((0.3 - directional) / 7.0, 0.0, 0.3);
    directional = mix(0.7, 1.0, directional * 2.0 * (0.2 + t) / 1.2);

    v_color.rgb *= directional;

    v_color *= opacity;
    v_color += shadow * u_shadow;
}
