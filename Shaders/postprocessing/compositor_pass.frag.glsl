#version 450

#ifdef GL_ES
precision mediump float;
#endif

#define FXAA_SPAN_MAX 8.0
#define FXAA_REDUCE_MUL   (0.25 / FXAA_SPAN_MAX)
#define FXAA_REDUCE_MIN   (1.0 / 32.0)
#define FXAA_SUBPIX_SHIFT 0.75

uniform sampler2D textureMap;
uniform vec2 resolution;
// 0 - posterizeGamma;
// 1 - posterizeSteps;
// 2 - vignetteStrength;
uniform float Params[3];

in vec2 fragCoord;
out vec4 fragColor;

vec3 FXAA(vec4 uv, sampler2D tex, vec2 rcpFrame) {
    vec3 rgbNW = texture(tex, uv.zw).rgb;
    vec3 rgbNE = texture(tex, uv.zw + vec2(1, 0) * rcpFrame).rgb;
    vec3 rgbSW = texture(tex, uv.zw + vec2(0, 1) * rcpFrame).rgb;
    vec3 rgbSE = texture(tex, uv.zw + vec2(1, 1) * rcpFrame).rgb;
    vec3 rgbM = texture(tex, uv.xy).rgb;

    vec3 luma = vec3(0.299, 0.587, 0.114);
    float lumaNW = dot(rgbNW, luma);
    float lumaNE = dot(rgbNE, luma);
    float lumaSW = dot(rgbSW, luma);
    float lumaSE = dot(rgbSE, luma);
    float lumaM = dot(rgbM, luma);

    float lumaMin = min(lumaM, min(min(lumaNW, lumaNE), min(lumaSW, lumaSE)));
    float lumaMax = max(lumaM, max(max(lumaNW, lumaNE), max(lumaSW, lumaSE)));

    vec2 dir = vec2(
            lumaSW + lumaSE - lumaNW - lumaNE,
            lumaNW + lumaSW - lumaNE - lumaSE
        );

    float dirReduce = max((lumaNW + lumaNE + lumaSW + lumaSE) * FXAA_REDUCE_MUL, FXAA_REDUCE_MIN);
    float rcpDirMin = 1.0 / (min(abs(dir.x), abs(dir.y)) + dirReduce);

    dir = min(vec2(FXAA_SPAN_MAX), max(vec2(-FXAA_SPAN_MAX), dir * rcpDirMin)) * rcpFrame;

    vec3 rgbA = 0.5 * (texture(tex, uv.xy + dir * -0.167).rgb + texture(tex, uv.xy + dir * 0.167).rgb);
    vec3 rgbB = 0.5 * (rgbA + 0.5 * (texture(tex, uv.xy + dir * -0.5).rgb + texture(tex, uv.xy + dir * 0.5).rgb));

    float lumaB = dot(rgbB, luma);
    if (lumaB < lumaMin || lumaB > lumaMax)
        return rgbA;

    return rgbB;
}

vec3 posterize(vec3 col, float gamma, float steps) {
    col = pow(col, vec3(gamma));
    col = floor(col * steps) / steps;
    col = pow(col, vec3(1.0 / gamma));
    return col;
}

float vignette(vec2 coord, float strength, vec2 resolution) {
    vec2 center = resolution * 0.5;
    float normalizedDist = distance(coord, center) / distance(vec2(0.0), center);
    float vignetteValue = 1.0 - pow(normalizedDist, strength);
    return clamp(vignetteValue, 0.0, 1.0);
}

void main() {
    vec2 texelSize = 1.0 / resolution;

    // fetch compositor parameters
    float posterizeGamma = Params[0];
    float posterizeSteps = Params[1];
    float vignetteStrength = Params[2];

    // fxaa
    vec4 uv = vec4(fragCoord, fragCoord - (texelSize * FXAA_SUBPIX_SHIFT));
    vec3 col = FXAA(uv, textureMap, texelSize);

    // posterize
    // col = posterize(col, posterizeGamma, posterizeSteps);

    // vignette
    // col *= vignette(fragCoord, vignetteStrength, resolution);

    fragColor = vec4(col, 1.0);
}
