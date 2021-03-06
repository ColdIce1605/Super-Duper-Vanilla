#version 120

/* Blur and bloom goes here */

#include "/lib/settings.glsl"
#include "/lib/globalVar.glsl"
#include "/lib/util.glsl"

#include "/lib/frameBuffer.glsl"

IN vec2 texcoord;

void main(){
	vec3 albedo = texture2D(gcolor, texcoord).rgb;

	#ifdef AUTO_EXPOSURE
		float autoExposure = maxC(texture2D(colortex6, vec2(0.5), log2(viewWidth * 0.4)).rgb);
		albedo *= EXPOSURE * mix(SHADOW_EXPOSURE, HIGHLIGHT_EXPOSURE, autoExposure);

		vec3 currentBuffer = texture2D(gcolor, vec2(0.5), exp2(viewWidth * 0.6)).rgb;
		vec3 prevBuffer = texture2D(colortex6, vec2(0.5), exp2(viewWidth * 0.4)).rgb;
		vec3 mixBuffer = mix(currentBuffer, prevBuffer, 0.98);
	#else
		albedo *= EXPOSURE;
	#endif
/* DRAWBUFFERS:03 */
	gl_FragData[0] = vec4(saturate(albedo), 1.0); //gcolor
	gl_FragData[1] = vec4(saturate(albedo * hermiteMix(BLOOM_THRESHOLD, BLOOM_AMOUNT, A_Saturation(albedo, 0.0).r)), 1.0); // colortex3

	#ifdef AUTO_EXPOSURE
	/* DRAWBUFFERS:036 */
		gl_FragData[2] = vec4(mixBuffer, 1.0); //colortex6
	#endif
}