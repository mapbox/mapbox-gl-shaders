#ifdef GL_ES
precision mediump float;
#else
#define lowp
#define mediump
#define highp
#endif

// #ifndef MAPBOX_GL_JS
uniform sampler2D u_texture;
uniform float u_opacity;
// #endif

varying vec2 v_pos;

// TODO here we'll probably want to add ability to fade in...
// #ifndef MAPBOX_GL_JS
// varying vec2 v_pos;
// #else
// uniform float u_opacity0;
// uniform float u_opacity1;
// uniform sampler2D u_image0;
// uniform sampler2D u_image1;
// varying vec2 v_pos0;
// varying vec2 v_pos1;
// #endif

void main() {
    gl_FragColor = texture2D(u_texture, v_pos) * u_opacity + vec4(0.1,0.0,0.0,0.1);
    // gl_FragColor = vec4(1.0,0.1,0.1,1.0);
}
