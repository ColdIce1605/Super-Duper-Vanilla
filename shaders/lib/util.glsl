// --------------- Code Library ---------------- //
// All main codes will be gathered here in this file

#define OUT varying
#define IN varying

// Saturate / clamp functions
float saturate(float x) { return clamp(x, 0.0, 1.0); }
vec2 saturate(vec2 x) { return clamp(x, vec2(0.0), vec2(1.0)); }
vec3 saturate(vec3 x) { return clamp(x, vec3(0.0), vec3(1.0)); }
vec4 saturate(vec4 x) { return clamp(x, vec4(0.0), vec4(1.0)); }

// Squared functions x^2
float squared(float x) { return x * x; }
vec2 squared(vec2 x) { return x * x; }
vec3 squared(vec3 x) { return x * x; }
vec4 squared(vec4 x) { return x * x; }

// Cubed functions x^3
float cubed(float x) { return x * x * x; }
vec2 cubed(vec2 x) { return x * x * x; }
vec3 cubed(vec3 x) { return x * x * x; }
vec4 cubed(vec4 x) { return x * x * x; }

// Max functions
float max2(vec2 x) { return max(x.r, x.g); }
float maxC(vec3 x) { return max(x.r, max(x.g, x.b)); }
float maxC(vec4 x) { return max(x.r, max(x.g, max(x.b, x.a))); }

// Min functions
float min2(vec2 x) { return min(x.r, x.g); }
float minC(vec3 x) { return min(x.r, min(x.g, x.b)); }
float minC(vec4 x) { return min(x.r, min(x.g, min(x.b, x.a))); }

// Hermite interpolation
float hermiteMix(float a, float b, float x) { return saturate((x - a) / (b - a)); }
vec2 hermiteMix(float a, float b, vec2 x) { return saturate((x - a) / (b - a)); }
vec3 hermiteMix(float a, float b, vec3 x) { return saturate((x - a) / (b - a)); }
vec4 hermiteMix(float a, float b, vec4 x) { return saturate((x - a) / (b - a)); }
vec2 hermiteMix(vec2 a, vec2 b, vec2 x) { return saturate((x - a) / (b - a)); }
vec3 hermiteMix(vec3 a, vec3 b, vec3 x) { return saturate((x - a) / (b - a)); }
vec4 hermiteMix(vec4 a, vec4 b, vec4 x) { return saturate((x - a) / (b - a)); }

// Smoothstep functions
float smoothen(float x){
	x = saturate(x);
	return x * x * (3.0 - 2.0 * x);
	}

vec2 smoothen(vec2 x){
	x = saturate(x);
	return x * x * (3.0 - 2.0 * x);
	}

vec3 smoothen(vec3 x){
	x = saturate(x);
	return x * x * (3.0 - 2.0 * x);
	}

vec4 smoothen(vec4 x){
	x = saturate(x);
	return x * x * (3.0 - 2.0 * x);
	}

// Smootherstep functions
float smootherstep(float x){
	x = saturate(x);
	return cubed(x) * (x * (x * 6. - 15.) + 10.);
	}

vec2 smootherstep(vec2 x){
	x = saturate(x);
	return cubed(x) * (x * (x * 6. - 15.) + 10.);
	}

vec3 smootherstep(vec3 x){
	x = saturate(x);
	return cubed(x) * (x * (x * 6. - 15.) + 10.);
	}

vec4 smootherstep(vec4 x){
	x = saturate(x);
	return cubed(x) * (x * (x * 6. - 15.) + 10.);
	}

// Saturation function
vec3 A_Saturation(vec3 col, float a){
	// Algorithm from Chapter 16 of OpenGL Shading Language
	return (col.r * 0.2125 + col.g * 0.7154 + col.b * 0.0721) * (1.0 - a) + col * a;
}

// Contrast function
vec3 A_Contrast(vec3 col, float a){
	return saturate(0.5 * (1. - a) + col.rgb * a);
}

// Rotation function
mat2 rot2D(float x){
    return mat2(cos(x),-sin(x), sin(x),cos(x));
}

// Biome/Environment detectors, these determine certain conditions
// according to the environmental changes around the player

// Color picker using an rgb2hsv converter, used to select multiple colors
// and compare it with another color, this is needed for color-accurate
// info on the biome environment. Taken from:
// http://lolengine.net/blog/2013/07/27/rgb-to-hsv-in-glsl
vec3 rgb2hsv(vec4 c){
	vec4 K = vec4(0, -1. / 3., 2. / 3., -1);
	vec4 p = c.g < c.b ? vec4(c.bg, K.wz) : vec4(c.gb, K.xy);
	vec4 q = c.r < p.x ? vec4(p.xyw, c.r) : vec4(c.r, p.yzx);
	float d = q.x - min(q.w, q.y);
	float e = 1e-10;
	return vec3(abs(q.z + (q.w - q.y) / (6. * d + e)), d / (q.x + e), q.x);
}

vec3 rgb2hsv(vec3 c){
	vec4 K = vec4(0, -1. / 3., 2. / 3., -1);
	vec4 p = c.g < c.b ? vec4(c.bg, K.wz) : vec4(c.gb, K.xy);
	vec4 q = c.r < p.x ? vec4(p.xyw, c.r) : vec4(c.r, p.yzx);
	float d = q.x - min(q.w, q.y);
	float e = 1e-10;
	return vec3(abs(q.z + (q.w - q.y) / (6. * d + e)), d / (q.x + e), q.x);
}

// For converting hsv to rgb
vec3 hsv2rgb(vec4 c){
	vec4 K = vec4(1, 2. / 3., 1. / 3., 3);
	vec3 p = abs(fract(c.xxx + K.xyz) * 6. - K.www);
	return vec3(c.z * mix(K.xxx, clamp(p - K.xxx, 0., 1.), c.y));
}

// For converting hsv to rgb
vec3 hsv2rgb(vec3 c){
	vec4 K = vec4(1, 2. / 3., 1. / 3., 3);
	vec3 p = abs(fract(c.xxx + K.xyz) * 6. - K.www);
	return vec3(c.z * mix(K.xxx, clamp(p - K.xxx, 0., 1.), c.y));
}

// Other functions and helpful variables
#define MIX2(x, y, z, w) w < .5 ? mix(x, y, saturate((w) / .5)) : mix(y, z, saturate(((w) - .5) / .5))
#define GENWAVES(x, y, z) (sin(dot(x, y)) * z)
#define GENWAVEC(x, y, z) (cos(dot(x, y)) * z)

// Noise functions, all the values are hardcoded to highp, don't change precisions
// Seeds, (adjust it if you like)
vec4 s0 = vec4(12.9898, 4.1414, 78.233, 314.13);
// Must be 1 integer apart ex. 0.36, 1.36, 2.36.....
vec4 s1 = vec4(0.1031, 1.1031, 2.1031, 3.1031);

// Noise functions
// 1 out, 2 in...
float rand12(vec2 n){
	return fract(sin(dot(n, s0.xy)) * 1e4);
}

// 2 out, 2 in...
vec2 rand22(vec2 n){
	return fract(sin(vec2(dot(n, s0.xy), dot(n, s0.zw))) * 1e4);
}

// 3 out, 2 in...
vec3 rand32(vec2 n){
	return fract(sin(vec3(dot(n, s0.xy), dot(n, s0.yz), dot(n, s0.zw))) * 1e4);
}
	
// 3 out, 3 in...
vec3 rand33(vec3 n){
	return fract(sin(vec3(dot(n, s0.xyz), dot(n, s0.yzw), dot(n, s0.zwx))) * 1e4);
}

// Random noise alternatives with a larger range but more performance heavy
// 1 out, 1 in...
float hash11(float p){
	float p1 = fract(p * s1.x);
	p1 *= p1 + 33.33;
	return fract(p1 * p1 * 2.0);
}

// Modified value noise for the beams
float vnoise(float p){
	float i = floor(p); float f = fract(p);
	return mix(hash11(i), hash11(i + 1.), f * f * f * (f * (f * 6. - 15.) + 10.));
}

float vnoise(vec2 p, float time, float tiles){
	p = p * tiles + time;
	vec2 i = floor(p); vec2 f = fract(p);
	vec2 u = f * f * f * (f * (f * 6. - 15.) + 10.);
	return mix(mix(rand12(mod(i, tiles)), rand12(mod(i + vec2(1.0, 0.0), tiles)), u.x), mix(rand12(mod(i + vec2(0.0, 1.0), tiles)), rand12(mod(i + 1.0, tiles)), u.x), u.y);
}

// Voronoi
float voronoi2D(vec2 uv, float time, float tiles){
	uv *= tiles; float dist = 1.;
	for(int x = 0; x <= 1; x++){
		for(int y = 0; y <= 1; y++){
			vec2 p = floor(uv) + vec2(x, y);
			float d = length(.27 * sin(rand22(mod(p, tiles)) * 12.0 + time) + vec2(x, y) - fract(uv));
			dist = min(d, dist);
		}
	}
	return dist;
}