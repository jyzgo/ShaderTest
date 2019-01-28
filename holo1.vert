#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	
	vec2 p = (gl_FragCoord.xy * 2.0 - resolution) / min(resolution.x, resolution.y);
	
	float color = 0.01/abs(0.5 - length(p));
	
	vec2 v = vec2(sin(time), 0.2);
	
	
	// wave ring
	float u = sin((atan(p.y, p.x) + time * 0.3) * 30.0) * 0.01;
	float t = 0.01 * abs(sin(time)) * 2. / abs(0.5 + u - length(p));
	
	float u2 = sin((atan(p.y, p.x) + time * 0.1) * 30.0) * 0.01;
	float t2 = 0.01 * abs(sin(time)) * 0.1 / abs(0.5 + u2 - length(p));
	
	float u3 = sin((atan(p.y, p.x) + time * 0.5) * 30.0) * 0.01;
	float t3 = 0.01 * abs(sin(time)) / abs(0.5 + u3 - length(p));
	
	vec3 cl = max( vec3(t3, t2, t), vec3(0.01/abs(0.2 + u3 - length(p)), t2, t));



	gl_FragColor = vec4( cl, 1. );

}