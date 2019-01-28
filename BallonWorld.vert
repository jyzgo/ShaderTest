#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

//rat marching

const float PI = 3.14159265;

float angle = 60.0;
float fov = angle * 0.5 * PI / 180.0;

//camera
vec3 cameraPos = vec3(0.0,0.0,2.0);

//sphere
const float sphereSize = 1.0;

//light
vec3 lightDir = vec3(-0.577,0.577,0.577);
vec3 lightColor = vec3(0.343,0.633,0.674);

vec3 trans(vec3 pos)
{
	return mod(pos,4.0) - 2.0;	// -2.0 ～ 1.99999
}

float distanceSphere(vec3 pos)
{
	return length(trans(pos)) - sphereSize;
}

vec3 getNormal(vec3 pos)
{
	float d = 0.0001;
	return normalize(vec3(
		distanceSphere(pos + vec3(d,0.0,0.0)) - distanceSphere(pos + vec3(-d,0.0,0.0)),
		distanceSphere(pos + vec3(0.0,d,0.0)) - distanceSphere(pos + vec3(0.0,-d,0.0)),
		distanceSphere(pos + vec3(0.0,0.0,d)) - distanceSphere(pos + vec3(0.0,0.0,-d))
	));
}

void main( void ) {

	vec2 fragPos = (gl_FragCoord.xy * 2.0 - resolution) / min(resolution.x,resolution.y);
	
	vec3 ray = normalize(vec3(sin(fov) * fragPos.x,sin(fov) * fragPos.y,-cos(fov)));
	
	//move
	cameraPos += vec3(0.0,0.0,-time * 0.7);
	lightColor += vec3(pow(1.1,sin(time * 0.2)),sin(time * 0.2),cos(time * 2.0));
	
	float dist = 0.0;
	float rayLength = 0.0;
	vec3 rayPos = cameraPos;
	for(int i = 0;i < 64;++i)
	{
		dist = distanceSphere(rayPos);
		rayLength += dist;
		rayPos = cameraPos + ray * rayLength;
	}
	
	//hit check
	if(abs(dist) < 0.001)
	{
		vec3 normal = getNormal(rayPos);
		float diff = clamp(dot(lightDir,normal),0.1,1.0);
		gl_FragColor = vec4(vec3(diff) * lightColor ,1.0);
	}
	else
	{
		gl_FragColor = vec4(vec3(0.0),1.0);
	}
		

}