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

void main() {
    #pragma mapbox: initialize lowp float minH
    #pragma mapbox: initialize lowp float maxH
    gl_FragColor = v_color;
}
