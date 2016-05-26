#ifdef GL_ES
precision mediump float;
#else
#define lowp
#define mediump
#define highp
#endif

varying vec4 v_color;

void main() {
    gl_FragColor = v_color;
}
