#ifdef GL_ES
precision highp float;
#else
#define lowp
#define mediump
#define highp
#endif

attribute vec2 a_pos;
attribute vec3 a_normal;
attribute float a_edgedistance;
uniform mat4 u_matrix;
uniform vec3 u_lightdir;
uniform vec4 u_shadow;
uniform lowp vec4 u_outline_color;
varying vec4 v_color;

#ifndef MAPBOX_GL_JS
attribute float minH;
attribute float maxH;
#else
#pragma mapbox: define lowp float minH
#pragma mapbox: define lowp float maxH
#endif

#pragma mapbox: define lowp vec4 color

void main() {
#ifdef MAPBOX_GL_JS
    #pragma mapbox: initialize lowp float minH
    #pragma mapbox: initialize lowp float maxH
#endif
    #pragma mapbox: initialize lowp vec4 color

    float ed = a_edgedistance; // use each attrib in order to not trip a VAO assert
    float t = mod(a_normal.x, 2.0);

    gl_Position = u_matrix * vec4(a_pos, t > 0.0 ? maxH : minH, 1);

#ifdef OUTLINE
    #ifdef DEFAULT_COLOR
    v_color = color;
    #else
    v_color = u_outline_color;
    #endif
#else
    v_color = color;
#endif

    float directional = clamp(dot(a_normal / 32768.0, u_lightdir), 0.0, 1.0);
    float shadow = clamp((0.3 - directional) / 7.0, 0.0, 0.3);
    directional = mix(0.7, 1.0, directional * 2.0 * (0.2 +
        pow(t * clamp(maxH / 150.0, 0.0, 1.0), 0.25)
    ) / 1.2);

    v_color.rgb *= directional;

    v_color += shadow * u_shadow;
}
