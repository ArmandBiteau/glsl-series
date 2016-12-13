// Author: Armand Biteau
// Title: Eyes series

#ifdef GL_ES
precision mediump float;
#endif

#define PI 3.14159265359

#define EYE_TYPE 2

#define ITERATIONS 26

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

mat2 rotationMatrix(float cosFactor, float sinFactor)
{
    return mat2(cosFactor, sinFactor, -sinFactor, cosFactor);
}

void main() {

    float scale = 12.0;
    float time = u_time * 2.5;

    vec2 center = vec2(0., 0.);

    vec2 eyePosition = (center / u_resolution.xy);

    vec2 coords = gl_FragCoord.xy;

    vec2 uv = coords / u_resolution.xy - vec2(0.5) + eyePosition;
    uv *= vec2(scale);

    if (EYE_TYPE == 3)
    {
        float angle = - PI / 4.15;
        uv = uv * rotationMatrix(cos(angle), sin(angle));
	}

    float len = dot(uv, uv) * .3 - .7;

    vec3 noise = sin(time * vec3(0.75,0.72,0.7)) / 303.5;

    for (int i = 0; i < ITERATIONS; i++) {

        if (EYE_TYPE == 1) noise += cos(noise.xyz + uv.yxy * float(i) / 1.2 * len * ( 1.1 + sin(time * 1.0) / 15.0 ) );

        if (EYE_TYPE == 2) noise -= sin(noise.yxy + uv.yxy * float(i) / 0.95 * len * ( .95 + cos(time * .75) / 15.0 ) );

        if (EYE_TYPE == 3) noise -= sin(noise.zxz + uv.yxx * float(i / 2) * len * ( 1.5 + cos(time * .9) / 15.0 ) );

        if (EYE_TYPE == 4) noise += cos(noise.yxz + uv.yxy * float(i / 4) * len * ( 1.75 + sin(time * .7) / 15.0 ) );

    }

    float val = 0.0;

    if (EYE_TYPE == 1)
    {
   		val = noise.r * .05 + .43;
    	val -= smoothstep(.35, -.1, len) * 1.1 + len * .24 - .4;
	}

     if (EYE_TYPE == 2)
     {
   		val = noise.r * .05 + .13;
        val = pow(val, 0.7);
    	val -= smoothstep(.01, -.4, len) * 1.2 + len * .2 - .3;
	}

    if (EYE_TYPE == 3)
    {
   		val = noise.r * .04 + .3;
    	val -= smoothstep(.02, -.16, len) * 1.22 + len * .223 - .33;
	}

    if (EYE_TYPE == 4)
    {
   		val = noise.r * .04 + .4;
    	val -= smoothstep(.01, -.15, len) * 1.1 + len * .25 - .2;
	}

    gl_FragColor = vec4(vec3(max(val, .1)), 1.0);

}
