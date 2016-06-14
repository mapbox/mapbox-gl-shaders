#ifdef GL_ES
precision mediump float;
#else
#define lowp
#define mediump
#define highp
#endif

varying vec4 v_color;
#pragma mapbox: define lowp float minH
#pragma mapbox: define lowp float maxH
#pragma mapbox: define lowp vec4 color
#pragma mapbox: define highp float opacity

void main() {
    #pragma mapbox: initialize lowp float minH
    #pragma mapbox: initialize lowp float maxH
    #pragma mapbox: initialize lowp vec4 color
    #pragma mapbox: initialize highp float opacity

    gl_FragColor = v_color;
}
